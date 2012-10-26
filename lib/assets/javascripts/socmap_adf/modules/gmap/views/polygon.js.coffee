class ADF.GMap.Views.Polygon extends ADF.MVC.Views.Base
  
  label: false
  content: false 
  withLabel: false
  initialized: false
  
  initialize: () ->
    @mapView = @options.mapView
    @zone = @options.model
    @polygon = @zone.mapObject
    @label = @options.label if @options.label?
    @content = @options.content if @options.content?
    @withLabel = @options.withLabel if @options.withLabel?
    @_initCallbacksFromOptions()

  initZone: (allowDraw) -> 
    @initialized = true
    @map = @mapView.getMap().getGMap()
    if @zone.isNew() && allowDraw
      @startDrawing()
    else 
      @setPolygonMap( @map )
      @setPolygonHandlers()
      @_initLabelView() if @withLabel
      @onPolygonDrawCompleted() if allowDraw

    @mapView.getMap().addOverlay(@)
    @onZoneInitialized()
      
  _initCallbacksFromOptions: () ->
    @onShapeClicked = @options.onShapeClicked if typeof @options.onShapeClicked == 'function'
    @onPolygonDrawCompleted =  @options.onPolygonDrawCompleted if typeof @options.onPolygonDrawCompleted == 'function'
    @onPolygonDrawStarted = @options.onPolygonDrawStarted if typeof @options.onPolygonDrawStarted == 'function'
    @onPathChanged = @options.pathChanged if typeof @options.pathChanged == 'function'

  _initLabelView: () ->
    @labelView = new ADF.Map.Views.PolygonLabel
      point: @getCenter()
      map : @mapView.getMap()
      model: @zone
      label: if @label && @label.length > 0 then @label else null
      content: @content
      clickable: false
      hidden: true
      template: @zonePopupTemplate
            
  isClustering: () ->
    false
    
  removeFromMap: () -> # Depricated
    @zone.removeFromMap()
    @labelView.remove() if @labelView
    
  remove: () ->
    @polygon.getPolygon().setMap(null)
    @labelView.remove() if @labelView
  
  addContextMenu: () ->
    @contextMenu = new ADF.GMap.Views.ContextMenu({gElement : @polygon.getPolygon(), mapModel: @mapView.getMap()})
    @contextMenu.render()

# HELPERS
  setContent: ( content ) ->
    return unless @labelView
    @content = content
    @labelView.setContent( content )
    @labelView.render()
    
  setLabel: ( label) ->
    return unless @labelView
    @label = label
    @labelView.setLabel @label

  setLabelPosition: () ->
    point = @getCenter()
    @labelView.overlay.setPosition point
  
  getZone: ->
    @zone
  
  clearSelection: => 
    @setUnEditable( ) 

  setMap: (map) ->
    @setPolygonMap( map )
      
  getCenter: () ->
    bounds = new google.maps.LatLngBounds()
    i = 0
    while i < @polygon.getPolygon().getPath().length
     bounds.extend(@polygon.getPolygon().getPath().getAt(i))
     i++
    bounds.getCenter()

  setFirstCoordinate: (latLng) ->
    @first_coordinate = latLng

  getFirstCoordinate: ->
    if @first_coordinate? then @first_coordinate else false 
        
# HANDLERS
  setPolygonHandlers: () ->
    google.maps.event.addListener @polygon.getPolygon(), 'click', @newShapeClickHandler if @isEditable()
    google.maps.event.addListener @polygon.getPolygon(), 'mouseout', @onMouseOut
    google.maps.event.addListener @polygon.getPolygon(), 'mouseover', @onMouseOver
    google.maps.event.addListener @polygon.getPolygon(), 'mousemove', @onMouseMove
    google.maps.event.addListener @map, 'click', @clearSelection
    google.maps.event.addListener @polygon.getPolygon().getPath(), 'set_at', @onPathChanged
    google.maps.event.addListener @polygon.getPolygon().getPath(), 'insert_at', @onPathChanged
    google.maps.event.addListener @polygon.getPolygon().getPath(), 'remove_at', @onPathChanged
    @setEditable()
  
  onMouseOut: (e) =>
    @labelView.hideOverlayAfterTime() if @labelView
      
  onMouseOver: (e) =>
    @labelView.openOverlayOnHover() if @labelView && !@isEditable() && @content
  
  onMouseMove: (e) =>
    @labelView.hide() if @isEditable() && @labelView && @labelView.opened

  newShapeClickHandler: ( e )  =>   
    @setEditable()
    @onShapeClicked()

  startDrawing: =>
    return if @zone.readOnly
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON
      polygonOptions: @zone.mapObject.polygon_options_defaults
      map: @map
      drawingControl: false

    @onPolygonDrawStarted()
    google.maps.event.addListener @drawingManager, 'polygoncomplete', @polygonCompleteHandler

  stopDrawing: ->
    @drawingManager.setDrawingMode null if @drawingManager
            
  polygonCompleteHandler: ( newShape ) =>
    @setPolygon( newShape )
    @setPolygonHandlers()
    @stopDrawing()
    @_initLabelView() if @withLabel
    @onPolygonDrawCompleted()
                 
# DELEGATE METHODS 
  setColors: (fillColor, strokeColor) ->
    @polygon.setColors(fillColor, strokeColor)

  setPolygon: ( polygon ) ->
    @polygon.setPolygon( polygon )

  setPolygonMap: ( map ) ->
    @polygon.setPolygonMap( map )

  setEditable: ( editable ) ->
    @polygon.setEditable( editable )

  setUnEditable: ( editable ) ->
    @polygon.setUnEditable( editable )

  setClickable: ( clickable ) ->
    @polygon.getPolygon().setOptions({clickable: clickable})

  isEditable: () ->
    @polygon.getPolygon().getEditable()
    
  setIdleOn: () =>
    
  setIdleOff: () =>
                   
# CALLBACKS
  onPolygonDrawCompleted: =>   
  onPolygonDrawStarted: =>
  onShapeClicked: =>
  onPathChanged: =>
  onZoneInitialized: =>