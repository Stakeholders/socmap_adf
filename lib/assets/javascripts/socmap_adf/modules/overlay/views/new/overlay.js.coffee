ADF.Overlay.Views.New ||= {}

class ADF.Overlay.Views.New.Default extends ADF.GMap.Views.OverlayView 
  
  hidden: false
  draggable: true
  clickEvent: null
  
  constructor: (options) ->
    super(options)
    @clickableArea = if options.area then options.area else @map.getGMap()
    @initOverlay()

  initOverlay: () ->
    if not @overlay 
      if @point && @point.lat() > 0 && @point.lng() > 0
        @pushOverlay()
      else
        @bindMap()
    else
      @overlay.view = @
      @redraw()

  bindMap: () ->
    @clickEvent = google.maps.event.addListener @clickableArea, 'click', @onClicked unless @clickEvent?
    
  unbindMap: () ->
    google.maps.event.removeListener(@clickEvent) if @clickEvent?
    @clickEvent = null
    
  onClicked: (e) =>
    @point = e.latLng
    @unbindMap()
    @pushOverlay()