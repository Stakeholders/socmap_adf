class ADF.GMap.Views.Overlay extends google.maps.OverlayView

  hidden: true
  topPoint: null
  zindex: 1
  divPixel: null

  constructor: (map, view) ->
    @map = map
    @view = view
    @setMap(@map)
    @hidden = @view.hidden
    @clickable = @view.clickable
    @hoverable = @view.hoverable
    @showAfterDrag = @view.showAfterDrag
    @view.overlay = @
    @initMarker()
    @bindMapEvents()
    
  # = Marker Methods  
  initMarker: () ->
    @options =
      position: @view.point,
      map: @map
      draggable: @view.draggable
      zIndex: 1
    if @view.getCustomMarker()
      @options.icon = @view.getCustomMarker().getIcon()
      @options.shadow = @view.getCustomMarker().getShadow()
      @options.shape = @view.getCustomMarker().getShape()
    else
      @options.icon = @view.icon if @view.icon
      @options.shadow = @view.shadow if @view.shadow
      @options.shape = @view.shape if @view.shape
    
    
    @options.cursor = "default"
    
    if @view.draggable
      @options.cursor = "move"
    if @clickable
      @options.cursor = "hand"
      
    if @view.label != null
      @options.labelContent = @view.label
      @options.labelClass = @view.labelClass
      @options.labelAnchor = new google.maps.Point(60, 0)
      @options.handCursor = @options.cursor
      @marker = new MarkerWithLabel @options
    else
      @marker = new google.maps.Marker @options
    @view.setMarker(@marker)
    @bindMarkerEvents()

  setDraggable: (draggable) ->
    @options.draggable = draggable
    @options.cursor = "hand"
    if @view.draggable
      @options.cursor = "move"
    if @clickable
      @options.cursor = "pointer"

    @marker.setOptions @options

  setLabel: () ->
    @marker.setMap(null)
    @initMarker()
    
  setMarkerIcon: () ->
    @marker.setIcon(@view.icon)

  getMarkerIcon: () ->
    @marker.getIcon()
    
  redrawMarker: () ->
    @marker.setMap(null) if @marker
    @initMarker()
    
  getMarker: () =>
    @marker

  isClustering: () ->
    @view.isClustering()

  getData: () ->
    @view.getData()

  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @marker, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @marker, 'dragend', (e) =>
      @view.point = e.latLng
      if @showAfterDrag
        @show()
        @draw()
      @view.onMarkerMoved(@view.point)
    
    @markerClickEvent = google.maps.event.addDomListener @marker, 'click', (e) =>
      if @view.clickable 
        @view.beforeMarkerClicked()
        if @hidden
          @show()  
          @draw()

    @markerMouseoverEvent = google.maps.event.addDomListener @marker, 'mouseover', (e) =>
      if @view.hoverable
        @view.onMarkerMouseOver()
      
    @markerMouseoutEvent = google.maps.event.addDomListener @marker, 'mouseout', (e) =>
      if @view.hoverable
        @view.onMarkerMouseOut()

  bindMapEvents: () ->
    @dragstartEvent = google.maps.event.addListener @map, 'dragstart', () =>
      @draw()

    @dragendEvent = google.maps.event.addListener @map, 'dragend', () =>
      @draw()

    @centerChangedEvent = google.maps.event.addListener @map, 'center_changed', () =>
      @draw()

  unbindMapEvents: () =>
    google.maps.event.removeListener(@dragstartEvent)
    google.maps.event.removeListener(@dragendEvent)
    google.maps.event.removeListener(@centerChangedEvent)   

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerClickEvent)
    google.maps.event.removeListener(@markerMouseoverEvent)
    google.maps.event.removeListener(@markerMouseoutEvent)
    google.maps.event.clearListeners(@getMarker(), "click")
    google.maps.event.clearListeners(@getMarker(), "mouseover")
    google.maps.event.clearListeners(@getMarker(), "mouseout")
      
  # = Show or Hide overlay
  show: ( animation = false ) ->
    @view.beforeOverlayShowed()
    if animation
      $(@div).fadeIn("fast")
    else
      $(@div).show()
    @hidden = false
    @view.onOverlayShowed()

  hide: ( animation = false ) ->
    $(@div).hide()
    @hidden = true

  hideMarker: () ->
    @hide()
    if @marker
      @marker.setMap(null)

  showMarker: () ->
    @show()
    @marker.setMap(@map)
    
  # = Set new position
  setPosition: (point) ->
    @view.point = point
    @marker.setPosition(point)
    @draw()

  getPosition: () ->
    @view.point
    
  getDivPixel: () ->
    @divPixel
    
  # = From OverlayView 
  onAdd: ->
    @div = @view.render().el
    if @view.asLabel
      @pane = @getPanes().overlayLayer
      @pane.appendChild(@div)
    else
      $(@view.getMapElement()).append(@div)
    @view.onMarkerAdded(@view.point)

  draw: () ->
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @view.point)
      if @view.asLabel
        @divPixel = overlayProjection.fromLatLngToDivPixel(@view.point)
      else
        @divPixel = overlayProjection.fromLatLngToContainerPixel(@view.point)
      
      @left = @divPixel.x + @view.left - (@view.getWidth() / 2)
      
      if @view.overlayPositionVertical == "top"
        @top = @divPixel.y + @view.top - @view.getHeight()
      else
        @top = @divPixel.y + @view.top

      if @top < 0
        point = new google.maps.Point(@left, (@top / 2) + ($(window).height() / 2))
        @topPoint = overlayProjection.fromDivPixelToLatLng(point)
      else
        @topPoint = @view.point
        
    if (@div != null)
      $(@div).css({position: "absolute", left: @left, top: @top, "z-index" : @zindex})

      if @hidden
        $(@div).hide()
          
      if !@hidden
        @show()

  onRemove: () ->
    @unbindMapEvents()
    @unbindMarkerEvents()
    $(@div).remove()
    @getMarker().setMap(null)
    @onMap = false
    
  setInFront: () ->
    @zindex = @zindex + 1
    @draw()

  setBack: () ->
    @zindex = @zindex - 1
    @draw()
  
  centerToOverlay: () ->
    if @topPoint
      @map.setCenter(@topPoint)
    else
      @map.setCenter(@view.point)

  centerPanToOverlay: (x = 0, y = 0) ->
    @map.panTo(@view.point)
    @map.panBy(x, y)

  centerToMarker: () ->
    @map.setCenter(@view.point)

  redraw: (event) ->
    @view.point = event.latLng
    @draw()