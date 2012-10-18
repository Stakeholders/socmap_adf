class ADF.OverlayPush.Views.FlashNew extends ADF.GMap.Views.OverlayView 
  
  hidden: false
  draggable: true
  clickEvent: null
  
  opened: false
  clickable: false
  hoverable: true
  calibration: [0, -16, -20, 0]
  mouseout: true
  
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
    
  onMarkerMouseOver: () =>
    @openOverlayOnHover()

  onMarkerMouseOut: () =>
    @hideOverlayAfterTime() if @mouseout

  openOverlayOnHover: () =>
    @map.hideAllOverlays()
    @opened = true
    @calculatePosition()
    @show()

  hideOverlayIfNeeded: () =>
    @hide() if !@opened

  hideOverlayAfterTime: () =>
    @opened = false
    setTimeout(@hideOverlayIfNeeded, 1000)

  onRenderCompleted: () =>
    if @hoverable && @mouseout
      $(@el).hover(@openOverlayOnHover, @hideOverlayAfterTime)

  calculatePosition: () ->
    arr = @getPositionArray()
    @setPosition(arr[0], arr[1])

  getPositionArray: () ->
    halfWidth = @map.getMapElement().width() / 2
    halfHeight = @map.getMapElement().height() / 2
    divPixel = @overlay.getDivPixel()
    w = @getWidth() / 2
    h = @getHeight()

    return [h + @calibration[0], w + @calibration[3]] if divPixel.x <= halfWidth && divPixel.y < halfHeight
    return [h + @calibration[0], -w + @calibration[1]] if divPixel.x > halfWidth && divPixel.y < halfHeight
    return [@calibration[2], w + @calibration[3]] if divPixel.x <= halfWidth && divPixel.y >= halfHeight
    return [@calibration[2], -w + @calibration[1]] if divPixel.x > halfWidth && divPixel.y >= halfHeight