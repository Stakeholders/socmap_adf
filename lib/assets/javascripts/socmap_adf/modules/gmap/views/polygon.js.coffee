class ADF.GMap.Views.Polygon extends ADF.MVC.Views.Base
  
  label: false
  content: false 
  
  initialize: () ->
    @mapView = @options.mapView
    @zone = @options.model
    @label = @options.label if @options.label?
    @content = @options.content if @options.content?
    @onShapeClicked = @options.onShapeClicked if typeof @options.onShapeClicked == 'function'
    @onPolygonDrawCompleted =  @options.onPolygonDrawCompleted if typeof @options.onPolygonDrawCompleted == 'function'
    @onPolygonDrawStarted = @options.onPolygonDrawStarted if typeof @options.onPolygonDrawStarted == 'function'
    @pathChanged = @options.pathChanged if typeof @options.pathChanged == 'function'
    @initialized = false
        
  initZone: (allowDraw) -> 
    @initialized = true
    @map = @mapView.getMap().getGMap()
    if @zone.isNew() && allowDraw
      @startDrawing()
    else 
      @zone.setPolygonMap( @map )
      @onPolygonDrawCompleted() if allowDraw
      @setPolygonHandlers() 
    @mapView.getMap().addOverlay(@)
    @setLabel() if @label
    @onZoneInitialized()
  
  isClustering: () ->
    false
      
  setLabel: () ->
    bounds = new google.maps.LatLngBounds()

    i = 0
    while i < @zone.getPolygon().getPath().length
      bounds.extend(@zone.getPolygon().getPath().getAt(i))
      i++
    point = bounds.getCenter()
 
    unless @labelView
      @labelView = new ADF.Map.Views.PolygonLabel
        point: point
        map : @mapView.getMap()
        model: @zone
        hidden: true
        label: @label
        content: @content
        clickable: false
        template: @zonePopupTemplate
    else
      @labelView.overlay.setPosition(point)
      @labelView.label = @label
      @labelView.content = @content
      @labelView.render()
    
  startDrawing: =>
    return if @zone.readOnly
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON
      polygonOptions: @zone.mapObject.polygon_options_defaults
      map: @map
      drawingControl: false

    @onPolygonDrawStarted()
    google.maps.event.addListener @drawingManager, 'polygoncomplete', @polygonCompleteHandler
 
  # stopDrawing: ->
  #   @drawingManager.setMap(null) if @drawingManager
  
  setFirstCoordinate: (latLng) ->
    @first_coordinate = latLng
    
  getFirstCoordinate: ->
    if @first_coordinate? then @first_coordinate else false
    
  stopDrawing: ->
    @drawingManager.setDrawingMode null if @drawingManager
            
  getZone: ->
    @zone

  setMap: (map) ->
    @zone.setPolygonMap(map)
  
  removeFromMap: () ->
    @zone.removeFromMap()
    @labelView.remove() if @labelView
  
  polygonCompleteHandler: ( newShape ) =>
    @zone.setPolygon( newShape )
    @setPolygonHandlers()
    @onPolygonDrawCompleted()

  onMouseOut: (e) =>
    @labelView.hideOverlayAfterTime() if @labelView
      
  onMouseOver: (e) =>
    @labelView.openOverlayOnHover() if @labelView && !@isEditable() && @content
  
  onMouseMove: (e) =>
    @labelView.hide() if @isEditable() && @labelView && @labelView.opened
      
  setPolygonHandlers: () ->
    google.maps.event.addListener @zone.getPolygon(), 'click', @newShapeClickHandler
    google.maps.event.addListener @zone.getPolygon(), 'mouseout', @onMouseOut
    google.maps.event.addListener @zone.getPolygon(), 'mouseover', @onMouseOver
    google.maps.event.addListener @zone.getPolygon(), 'mousemove', @onMouseMove
    google.maps.event.addListener @map, 'click', @clearSelection
    google.maps.event.addListener @zone.getPolygon().getPath(), 'set_at', @pathChanged
    google.maps.event.addListener @zone.getPolygon().getPath(), 'insert_at', @pathChanged
    google.maps.event.addListener @zone.getPolygon().getPath(), 'remove_at', @pathChanged
    @zone.setEditable()
   
  
  isEditable: () ->
    @zone.getPolygon().getEditable()
     
  clearSelection: => 
    @zone.setUnEditable( )
      
  newShapeClickHandler: ( e )  =>   
    @zone.setEditable()
    @onShapeClicked()
  
  addContextMenu: () ->
    @contextMenu = new ADF.GMap.Views.ContextMenu({gElement : @zone.getPolygon(), mapModel: @mapView.getMap()})
    @contextMenu.render()
                   
  # Callback Methods
  onPolygonDrawCompleted: =>   
  onPolygonDrawStarted: =>
  onShapeClicked: =>
  pathChanged: =>
  onZoneInitialized: =>