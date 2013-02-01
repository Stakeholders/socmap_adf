ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Click extends ADF.Map.Views.Overlay.Content.Abstract
  
  opened: false
  openable: true

  bindMarkerEvents: () =>
    @unbindMarkerEvents()
    @markerDragstartEvent = google.maps.event.addListener @options.overlay, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @options.overlay, 'dragend', (e) =>
      @draw()
      @show() if @opened

    @markerClickEvent = google.maps.event.addDomListener @options.overlay, 'click', (e) =>
      # return if e.Ka.ctrlKey
      @open()

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerDragstartEvent)
    google.maps.event.removeListener(@markerDragendEvent)         
    google.maps.event.removeListener(@markerClickEvent)

  open: () ->
    if @openable
      @setMap(@options.overlay.getMap())
      @opened = true
      @draw()
      

  close: () ->
    @opened = false
    @setMap(null)

  draw: () ->
    super()
    @setMap(null) unless @opened