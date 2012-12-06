ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Click extends ADF.Map.Views.Overlay.Content.Abstract
  
  opened: false
  openable: true

  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @options.marker, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @options.marker, 'dragend', (e) =>
      @draw()
      @show() if @opened

    @markerClickEvent = google.maps.event.addDomListener @options.marker, 'click', (e) =>
      return if e.Ka.ctrlKey
      @open()

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerDragstartEvent)
    google.maps.event.removeListener(@markerDragendEvent)         
    google.maps.event.removeListener(@markerClickEvent)

  open: () ->
    if @openable
      @opened = true
      @draw()
      @show()

  close: () ->
    @opened = false
    @hide()

  draw: () ->
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @options.marker.getPosition() && @div)
      @divPixel = overlayProjection.fromLatLngToContainerPixel(@options.marker.getPosition())
      markerSize = @options.marker.options.icon.size
      markerWidth = markerSize.width
      markerHeight = markerSize.height
      overlayWidth = $(@div).width()
      overlayHeight = $(@div).height()
      
      @left = @divPixel.x - overlayWidth - @padding
      @top = @divPixel.y - markerHeight
        
    if (@div)
      $(@div).css({position: "absolute", left: @left, top: @top, "z-index" : @zindex})
      $(@div).hide() unless @opened