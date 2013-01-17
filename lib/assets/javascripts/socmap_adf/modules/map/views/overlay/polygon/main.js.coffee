ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Polygon ||= {}

class ADF.Map.Views.Overlay.Polygon.Main extends google.maps.Polygon
      
  constructor: (options) ->
    @options = options
    @eventBus = window.eventBus
    @events = {}
    @gEvents = []
    
    @beforeInitialize() if @beforeInitialize
    @options.mapModel.addOverlay(@) if @options.mapModel
    super(@options)
    if @getPath().length > 0
      @_fireWhenPathChanged()
    else
      @_setDrawingMode()
    @initialize() if @initialize
    
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
    
  getCoordinates: ->
    @getPath().getArray()

  getCenter: () ->
    bounds = new google.maps.LatLngBounds()
    bounds.extend(p) for p in @getPath().getArray()
    bounds.getCenter()

  getPosition: () ->
    @getCenter()

  centerPan: (x = 0, y = 0) ->
    @getMap().panTo(@getPosition())
    @getMap().panBy(x, y) 

  stopDrawing: ->
    @drawingManager.setDrawingMode null if @drawingManager
    
  # private
  
  # Overide
  setMap: (map) ->
    super(map)
    if map
      @fire("isOnMap")
    else
      @fire("removedFromMap")
      @drawingManager.setDrawingMode null if @drawingManager
      for event in @gEvents
        google.maps.event.removeListener event
      @gEvents = []
      @events = {}
  
  _setDrawingMode: () ->
    @options.editable = true
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON
      polygonOptions: @options
      map: @map
      drawingControl: false

    @fire("drawingStarted")
    google.maps.event.addListener @drawingManager, 'polygoncomplete', @_drawingCompleted

  _drawingCompleted: ( newShape ) =>
    @stopDrawing()
    @setPath(newShape.getPath())
    newShape.setMap(null)
    @setEditable(true)
    @_fireWhenPathChanged()
    @fire("drawingDone")
    @fire("onAdded")
    @fire("pathChanged")
    
  _fireWhenPathChanged: () =>
    google.maps.event.addListener @getPath(), 'set_at', @_pathMVCArrayChanged
    google.maps.event.addListener @getPath(), 'insert_at', @_pathMVCArrayChanged
    google.maps.event.addListener @getPath(), 'remove_at', @_pathMVCArrayChanged
    
  _pathMVCArrayChanged: () =>
    @fire("pathChanged")