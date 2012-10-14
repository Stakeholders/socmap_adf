class ADF.Overlay.Views.FlashOverlay extends ADF.GMap.Views.OverlayView
  
  opened: false
  hoverable: true
  top: -60
  left: 0
  
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
    @calculatePosition()
    @show()
    
  hideOverlayIfNeeded: () =>
    @hide() if !@opened

  hideOverlayAfterTime: () =>
    @opened = false
    setTimeout(@hideOverlayIfNeeded, 1000)

  onRenderCompleted: () =>
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
    
    return [h, w] if divPixel.x <= halfWidth && divPixel.y < halfHeight
    return [h, -w] if divPixel.x > halfWidth && divPixel.y < halfHeight
    return [@top, w] if divPixel.x <= halfWidth && divPixel.y >= halfHeight
    return [@top, -w] if divPixel.x > halfWidth && divPixel.y >= halfHeight