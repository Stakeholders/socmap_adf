ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Click extends google.maps.OverlayView
  
  opened: false
  openable: true

  constructor: (options) ->
    @options = options
    @setMap(@options.marker.getMap())
    @bindMarkerEvents()
    @bindMapEvents()
    @draw()

  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @options.marker, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @options.marker, 'dragend', (e) =>
      @draw()
      @show() if @opened

    @markerClickEvent = google.maps.event.addDomListener @options.marker, 'click', (e) =>
      return if e.Ka.ctrlKey
      @open()

  bindMapEvents: () ->
    @dragstartEvent = google.maps.event.addListener @getMap(), 'dragstart', () =>
      @draw()

    @dragendEvent = google.maps.event.addListener @getMap(), 'dragend', () =>
      @draw()

    @centerChangedEvent = google.maps.event.addListener @getMap(), 'center_changed', () =>
      @draw()

  unbindMapEvents: () =>
    google.maps.event.removeListener(@dragstartEvent)
    google.maps.event.removeListener(@dragendEvent)
    google.maps.event.removeListener(@centerChangedEvent)   

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerDragstartEvent)
    google.maps.event.removeListener(@markerDragendEvent)         
    google.maps.event.removeListener(@markerClickEvent)
      
  # = Show or Hide overlay
  show: ( animation = false ) ->
    if @div
      if animation
        $(@div).fadeIn("fast")
      else
        $(@div).show()

  hide: ( animation = false ) ->
    $(@div).hide() if @div
    
  open: () ->
    if @openable
      @opened = true
      @draw()
      @show()

  close: () ->
    @opened = false
    @hide()

  # = From OverlayView 
  onAdd: ->
    if @options.view
      @div = @options.view.render().el
      $(@options.marker.mapModel.getMapElement()).append(@div)

  draw: () ->
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @options.marker.getPosition() && @div)
      @divPixel = overlayProjection.fromLatLngToContainerPixel(@options.marker.getPosition())
            
      @left = @divPixel.x - $(@div).width()
      @top = @divPixel.y
        
    if (@div)
      $(@div).css({position: "absolute", left: @left, top: @top, "z-index" : @zindex})
      $(@div).hide() unless @opened

  onRemove: () ->
    @unbindMapEvents()
    @unbindMarkerEvents()
    $(@div).remove() if @div
    
  setInFront: () ->
    @zindex = @zindex + 1
    @draw()

  setBack: () ->
    @zindex = @zindex - 1
    @draw()

  redraw: (event) ->
    @draw()