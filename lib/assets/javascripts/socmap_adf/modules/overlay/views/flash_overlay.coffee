class ADF.Overlay.Views.FlashOverlay extends ADF.GMap.Views.OverlayView
  
  opened: false
  hoverable: true
  nw: [180, 470]
  sw: [-50, 470]
  ne: [180, 250]
  se: [-50, 250]
  
  constructor: (options) ->
    super(options)
    @clickable = false
    @pushOverlay()
    
  onMarkerMouseOver: () =>
    @openOverlayOnHover()
    
  onMarkerMouseOut: () =>
    @hideOverlayAfterTime()

  openOverlayOnHover: () =>
    @map.hideAllOverlays()
    @opened = true
    @calculateTopAndLeft()
    @show()
    
  hideOverlayIfNeeded: () =>
    @hide() if !@opened

  hideOverlayAfterTime: () =>
    @opened = false
    setTimeout(@hideOverlayIfNeeded, 1000)

  onRenderCompleted: () =>
    $(@el).hover(@openOverlayOnHover, @hideOverlayAfterTime)
    
  calculateTopAndLeft: () ->
    w = $(@el).width()
    h = $(@el).height()
    arr = @getPositionArray()
 
    @setPosition(arr[0], arr[1])
    
  getPositionArray: () ->
    halfWidth = @map.getMapElement().width() / 2
    halfHeight = @map.getMapElement().height() / 2
    divPixel = @overlay.getDivPixel()
    
    return @nw if divPixel.x <= halfWidth && divPixel.y < halfHeight
    return @ne if divPixel.x > halfWidth && divPixel.y < halfHeight
    return @sw if divPixel.x <= halfWidth && divPixel.y >= halfHeight
    return @se if divPixel.x > halfWidth && divPixel.y >= halfHeight