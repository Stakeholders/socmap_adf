ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Polyline ||= {}

class ADF.Map.Views.Overlay.Polyline.Main extends google.maps.Polyline
  
  constructor: (options) ->
    @options = options
    @eventBus = window.eventBus
    @events = {}
    @gEvents = []
    
    @beforeInitialize() if @beforeInitialize
    @_initDashedAndArrowedOptions()
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
    
  getCoordinates: ->
    @getPath().getArray()

  getCenter: () ->
    bounds = new google.maps.LatLngBounds()
    bounds.extend(p) for p in @getPath().getArray()
    bounds.getCenter()

  getPosition: () ->
    if @getPath().getLength() > 2
      return @getPath().getAt(Math.round(@getPath().getLength()/2) - 1)
    else
      return @getPath().getAt(0)

  centerPan: (x = 0, y = 0) ->
    @getMap().panTo(@getPosition())
    @getMap().panBy(x, y) 

  stopDrawing: ->
    @drawingManager.setDrawingMode null if @drawingManager
    
  completeDrawing: ->
    google.maps.event.trigger(@drawingManager, 'polylinecomplete') if @drawingManager

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
    @options.editable = true
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYLINE
      polylineOptions: @options
      map: @map
      drawingControl: false

    @fire("drawingStarted")
    google.maps.event.addListener @drawingManager, 'polylinecomplete', @_drawingCompleted

  _drawingCompleted: ( newShape ) =>
    @stopDrawing()
    @setPath(newShape.getPath())
    newShape.setMap(null)
    @_fireWhenPathChanged()
    @fire("drawingDone")
    @fire("onAdded")
    @fire("pathChanged")

  _fireWhenPathChanged: () =>
    google.maps.event.addListener @getPath(), 'set_at', @_pathChanged
    google.maps.event.addListener @getPath(), 'insert_at', @_pathChanged
    google.maps.event.addListener @getPath(), 'remove_at', @_pathChanged
    
  _pathChanged: () =>
    @fire("pathChanged")
    
  _initDashedAndArrowedOptions: () ->
    dash = {path: 'M 0,-1 0,1', strokeOpacity: 1, scale: 2, strokeWeight: @options.strokeWeight}
    arrow = {path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW, strokeOpacity: 1}
    if @options.dashed && @options.arrowed
      @options.strokeOpacity = 0
      @options.icons = [{icon: dash, offset: '0', repeat: '20px'}, {icon: arrow, offset: '100%'}]
    else if @options.dashed
      @options.strokeOpacity = 0
      @options.icons = [{icon: dash, offset: '0', repeat: '20px'}]
    else if @options.arrowed
      @options.icons = [{icon: arrow, offset: '100%'}]
    
  _initArrowLineOptions: () ->
    lineSymbol = 
    @options.icons = [{icon: lineSymbol, offset: '100%'}]