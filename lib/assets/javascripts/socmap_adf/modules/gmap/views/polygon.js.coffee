class ADF.GMap.Views.Polygon extends ADF.MVC.Views.Base
  
  initialize: () ->
    @mapView = @options.mapView
    @zone = @options.model
    @onShapeClickedCallback = @options.onShapeClicked
    @onPolygonDrawCompleted = @options.onPolygonDrawCompleted
    @onPolygonDrawStarted = @options.onPolygonDrawStarted
    @pathChanged = if typeof @options.pathChanged == 'function' then @options.pathChanged
    @initialized = false
        
  initZone: (allowDraw) -> 
    @initialized = true
    @map = @mapView.getMap().getGMap()
    if @zone.isNew() && allowDraw
      @startDrawing()
    else 
      @zone.setPolygonMap( @map )
      @onPolygonDrawCompleted() if @onPolygonDrawCompleted? && allowDraw
      @setPolygonHandlers() 
    @mapView.getMap().addOverlay(@)
  
  isClustering: () ->
    false
  
  setLabel: ( label ) ->
    bounds = new google.maps.LatLngBounds();

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
        hidden: false
        label: label
    else
      @labelView.point = point
      @labelView.label = label
      @labelView.render()
    
  startDrawing: ->
    return if @zone.readOnly
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON
      polygonOptions: @zone.mapObject.polygon_options_defaults
      map: @map
      drawingControl: false
      
    @onPolygonStartDrawing()
    @onPolygonDrawStarted() if @onPolygonDrawStarted?
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
    @onPolygonDrawComplete()
    @onPolygonDrawCompleted() if @onPolygonDrawCompleted?

  setPolygonHandlers: () ->
    google.maps.event.addListener @zone.getPolygon(), 'click', @newShapeClickHandler
    google.maps.event.addListener @map, 'click', @clearSelection
    google.maps.event.addListener @zone.getPolygon().getPath(), 'set_at', @pathChanged
    google.maps.event.addListener @zone.getPolygon().getPath(), 'insert_at', @pathChanged
    google.maps.event.addListener @zone.getPolygon().getPath(), 'remove_at', @pathChanged
    @zone.setEditable()
    
  clearSelection: => 
    @zone.setUnEditable( )
      
  newShapeClickHandler: ( e )  =>   
    @zone.setEditable()
    @onShapeClicked()
    @onShapeClickedCallback() if @onShapeClickedCallback?
                    
  # Callback Methods
  onPolygonDrawComplete: ->   
  onPolygonStartDrawing: ->
  onShapeClicked: ->
  pathChanged: =>