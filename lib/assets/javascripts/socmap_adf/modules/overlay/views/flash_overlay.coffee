class ADF.Overlay.Views.FlashOverlay extends ADF.GMap.Views.OverlayView
  
  opened: false
  clickable: false
  hoverable: true
  calibration: [0, -16, -20, 0]
  mouseout: true
  
  constructor: (options) ->
    super(options)
    @clickable = false
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