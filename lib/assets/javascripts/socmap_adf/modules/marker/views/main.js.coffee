class ADF.Marker.Views.Main extends ADF.MVC.Views.Base

  icon: false
  shadow: false
  shape: false
  draggable: false
  point: false
  label: null
  labelClass: "marker_label"
  customMarker: null
  clickable: true
  asLabel: false
  showAfterDrag: false
  clustering: false
  data: 1
  zindex: 1

  constructor: (options) ->
    super(options)
    @map = options.map
    @point = options.point
    @data = options.data if options.data?
    @initMarker()

  setMarkerIcon: (icon) ->
    @icon = icon
    @marker.setIcon(@icon)

  getMarkerIcon: () ->
    @icon

  setCustomMarker: (customMarker) ->
    @customMarker = customMarker
    @marker.setMap(null)
    @initMarker()

  getCustomMarker: () ->
    @customMarker

  isClustering: () ->
    @clustering

  getData: () ->
    @data

  setDraggable: (draggable) ->
    @draggable = draggable
    @overlay.setDraggable(@draggable)

  setLabel: (label) ->
    @label = label
    @overlay.setLabel()

  setMap: (map) ->
    @marker.setMap(map)

  getPosition: () ->
    @point

  getMap: () ->
    @marker.getMap()

  getMarker: () ->
    @marker
       
  setLabel: (label) ->
    @label = label
    @marker.setMap(null)
    @initMarker()

  center: () ->
    @map.getGMap().setCenter(@point)
    
  centerPan: (x = 0, y = 0) ->
    @map.getGMap().panTo(@point)
    @map.getGMap().panBy(x, y)

  initMarker: () ->
    @options =
      position: @point,
      map: @map.getGMap()
      draggable: @draggable
      zIndex: 1
    if @getCustomMarker()
      @options.icon = @getCustomMarker().getIcon()
      @options.shadow = @getCustomMarker().getShadow()
      @options.shape = @getCustomMarker().getShape()
    else
      @options.icon = @icon if @icon
      @options.shadow = @shadow if @shadow
      @options.shape = @shape if @shape
    
    @options.cursor = "hand"
    if @draggable
      @options.cursor = "move"
    if @clickable
      @options.cursor = "pointer"    

    if @label != null
      @options.labelContent = @label
      @options.labelClass = @labelClass
      @options.labelAnchor = new google.maps.Point(60, 0)
      @marker = new MarkerWithLabel @options
    else
      @marker = new google.maps.Marker @options
    @bindMarkerEvents()
    @map.addOverlay(@, true)

  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @marker, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @marker, 'dragend', (e) =>
      @point = e.latLng
      @onMarkerMoved(@point)
    
    @markerClickEvent = google.maps.event.addDomListener @marker, 'click', (e) =>
      if @clickable 
        @beforeMarkerClicked()

    @markerMouseoverEvent = google.maps.event.addDomListener @marker, 'mouseover', (e) =>
      if @hoverable
        @onMarkerMouseOver()
      
    @markerMouseoutEvent = google.maps.event.addDomListener @marker, 'mouseout', (e) =>
      if @hoverable
        @onMarkerMouseOut()

  # Callback methods
  beforeMarkerClicked: () ->
  onMarkerMouseOver: () ->
  onMarkerMouseOut: () ->