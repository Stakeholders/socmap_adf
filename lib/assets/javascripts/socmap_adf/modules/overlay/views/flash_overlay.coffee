class ADF.Overlay.Views.FlashOverlay extends ADF.GMap.Views.OverlayView
  
  opened: false
  hoverable: true
  nw: [180, 580]
  sw: [-50, 580]
  ne: [180, 380]
  se: [-50, 380]
  
  constructor: (options) ->
    super(options)
    @clickable = false
    @pushOverlay()
    
  onMarkerMouseOver: () =>
    @openOverlayOnHover()
    
  onMarkerMouseOut: () =>
    @opened = false
    setTimeout(@hideOverlayAfterTime, 1000)
  
  openOverlayOnHover: () =>
    @opened = true
    @calculateTopAndLeft()
    @show()
    
  hideOverlayAfterTime: () =>
    @hide() if !@opened
    
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