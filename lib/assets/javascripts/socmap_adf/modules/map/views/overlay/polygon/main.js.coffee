ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Polygon ||= {}

class ADF.Map.Views.Overlay.Polygon.Main extends google.maps.Polygon
  
  customOptions:
    defaults:
      strokeColor: "#f600ff"
      strokeOpacity: 0.8
      strokeWeight: 3
      fillColor: "#fb98ff"
      fillOpacity: 0.30
      editable: true
    readonly:
      strokeColor: "#FFFFFF"
      strokeOpacity: 1
      strokeWeight: 3
      fillColor: "#FFFFFF"
      fillOpacity: 0
      editable: false
      clickable: false
       
  constructor: (options) ->
    @options = options
    @eventBus = window.eventBus
    @events = {}
    @gEvents = []
    
    @beforeInitialize() if @beforeInitialize
    
    @options.shape = {
      coord: @customOptions.shapeCoord
      type: 'poly'
    }
    
    @options.mapModel.addOverlay(@)
    
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
  
  _setDrawingMode: () ->
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON
      polygonOptions: @customOptions.defaults
      map: @map
      drawingControl: false

    @fire("drawingStarted")
    google.maps.event.addListener @drawingManager, 'polygoncomplete', @_drawingCompleted

  stopDrawing: ->
    @drawingManager.setDrawingMode null if @drawingManager
    
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

  _drawingCompleted: ( newShape ) =>
    @stopDrawing()
    @setPath(newShape.getPath())
    newShape.setMap(null)
    @setEditable(true)
    @_fireWhenPathChanged()
    @fire("drawingDone")
    @fire("pathChanged")
    
  _fireWhenPathChanged: () =>
    google.maps.event.addListener @getPath(), 'set_at', @_pathChanged
    google.maps.event.addListener @getPath(), 'insert_at', @_pathChanged
    google.maps.event.addListener @getPath(), 'remove_at', @_pathChanged
    
  _pathChanged: () =>
    @fire("pathChanged")