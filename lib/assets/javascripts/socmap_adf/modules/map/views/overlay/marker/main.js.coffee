ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Marker ||= {}

class ADF.Map.Views.Overlay.Marker.Main extends google.maps.Marker
  
  customOptions:
    icon:
      url: "/assets/socmap_adf/modules/map/grey.png"
      size: new google.maps.Size(49,71)
      origin: new google.maps.Point(0,0)
      anchor: new google.maps.Point(25,71)
    shadow:
      url: "/assets/socmap_adf/modules/map/grey_shadow.png"
      size: new google.maps.Size(89,71)
      origin: new google.maps.Point(0,0)
      anchor: new google.maps.Point(25,71)
    shapeCoord: [31,0,34,1,36,2,37,3,39,4,40,5,41,6,42,7,43,8,44,9,44,10,45,11,46,12,46,13,46,14,47,15,47,16,48,17,48,18,48,19,48,20,48,21,48,22,48,23,48,24,48,25,48,26,48,27,48,28,48,29,48,30,48,31,47,32,47,33,47,34,46,35,46,36,45,37,44,38,44,39,43,40,42,41,42,42,41,43,40,44,40,45,39,46,38,47,38,48,37,49,36,50,36,51,35,52,34,53,34,54,33,55,33,56,32,57,31,58,31,59,30,60,30,61,29,62,29,63,28,64,27,65,27,66,26,67,26,68,25,69,25,70,24,70,23,69,22,68,22,67,21,66,21,65,20,64,20,63,19,62,18,61,18,60,17,59,17,58,16,57,16,56,15,55,14,54,14,53,13,52,12,51,12,50,11,49,10,48,10,47,9,46,8,45,8,44,7,43,6,42,6,41,5,40,4,39,4,38,3,37,2,36,2,35,1,34,1,33,1,32,0,31,0,30,0,29,0,28,0,27,0,26,0,25,0,24,0,23,0,22,0,21,0,20,0,19,0,18,0,17,1,16,1,15,2,14,2,13,2,12,3,11,4,10,4,9,5,8,6,7,7,6,8,5,9,4,11,3,12,2,14,1,17,0,31,0]
  
  constructor: (options) ->
    @options = options
    @eventBus = window.eventBus
    @events = {}
    @gEvents = []
    
    @customOptions = @options.customOptions if @options.customOptions
    
    @beforeInitialize() if @beforeInitialize
    
    @options.icon = @_createMarkerImage(@customOptions.icon) if @customOptions.icon
    @options.shadow = @_createMarkerImage(@customOptions.shadow) if @customOptions.shadow
    
    @options.shape = {
      coord: @customOptions.shapeCoord
      type: 'poly'
    }
    
    @options.mapModel.addOverlay(@)
    
    super(@options)
    @_setDrawingMode() unless @getPosition()
    
    @initialize() if @initialize    
  
  centerPan: (x = 0, y = 0) ->
    @getMap().panTo(@getPosition())
    @getMap().panBy(x, y)
    
  on: (event, callback, type=null) ->
    if @events[event]
      @events[event].push(callback)
    else
      @events[event] = [callback]
      
  fire: (event) ->
    if @events[event]
      for callback in @events[event]
        callback()
    
  addListener: (event, callback) ->
    @gEvents.push(google.maps.event.addListener @, event, callback)
    
  # private
  
  # Overide
  setMap: (map) ->
    super(map)
    if map
      @fire("isOnMap")
    else
      @fire("removedFromMap")
      for event in @gEvents
        google.maps.event.removeListener event
      @gEvents = []
      @events = {}

  _createMarkerImage: (options) ->
    new google.maps.MarkerImage(options.url, options.size, options.origin, options.anchor)

  _setDrawingMode: () ->
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.MARKER
      markerOptions: @options
      map: @map
      drawingControl: false

    @fire("drawingStarted")
    google.maps.event.addListener @drawingManager, 'markercomplete', @_drawingCompleted

  stopDrawing: ->
    @drawingManager.setDrawingMode null if @drawingManager
    
  _drawingCompleted: ( newMarker ) =>
    @stopDrawing()
    @setPosition(newMarker.getPosition())
    newMarker.setMap(null)
    @fire("drawingDone")
    @fire("onAdded")