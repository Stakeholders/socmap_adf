ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Flash extends ADF.Map.Views.Overlay.Content.Abstract
  
  mouseout: true
  hideAfter: 500
  opened: false
  
  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @options.overlay, 'dragstart', (e) =>
      @hide()
      
    @markerDragendEvent = google.maps.event.addListener @options.overlay, 'dragend', (e) =>
      @draw()
      @show()

    @markerMouseoutEvent = google.maps.event.addListener @options.overlay, 'mouseout', (e) =>
      @onMarkerMouseOut()

    @markerMouseoverEvent = google.maps.event.addDomListener @options.overlay, 'mouseover', (e) =>
      @openOverlayOnHover()

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerDragstartEvent)
    google.maps.event.removeListener(@markerDragendEvent)
    google.maps.event.removeListener(@markerMouseoutEvent)         
    google.maps.event.removeListener(@markerMouseoverEvent)

  onMarkerMouseOut: () =>
    @hideOverlayAfterTime() if @mouseout

  openOverlayOnHover: () =>
    @opened = true
    @show()

  hideOverlayIfNeeded: () =>
    @hide() if !@opened

  hideOverlayAfterTime: () =>
    @opened = false
    setTimeout(@hideOverlayIfNeeded, @hideAfter)

  draw: () ->
    super()
    $(@div).hover(@openOverlayOnHover, @hideOverlayAfterTime) if @div
    @hide()