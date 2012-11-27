class ADF.Overlay.Views.FlashOverlay extends ADF.GMap.Views.OverlayView
  
  opened: false
  hoverable: true
  calibration: [0, -16, -20, 0]
  mouseout: true
  openOnClick: false
  hideAfter: 50
  
  constructor: (options) ->
    super(options)
    @pushOverlay()
    @eventBus.on "ADF.GMap.Views.ContextMenu.isShowed", @hideAndSetIdleOn
    @eventBus.on "ADF.GMap.Views.ContextMenu.isHidden", @setIdleOff
    
  onMarkerMouseOver: () =>
    @openOverlayOnHover()
    
  onMarkerMouseOut: () =>
    @hideOverlayAfterTime() if @mouseout

  openOverlayOnHover: () =>
    if !@idleOn
      @map.hideAllOverlays()
      @opened = true
      @calculatePosition()
      @show()
    
  hideOverlayIfNeeded: () =>
    @hide() if !@opened

  hideOverlayAfterTime: () =>
    @opened = false
    setTimeout(@hideOverlayIfNeeded, @hideAfter)

  onRenderCompleted: () =>
    if @hoverable && @mouseout
      $(@el).hover(@openOverlayOnHover, @hideOverlayAfterTime)
    
  onMarkerDrag: () ->
    @map.hideAllOverlays()
    
  calculatePosition: () ->
    arr = @getPositionArray()
    @setPosition(arr[0], arr[1])
    
  setUnHoverable: () =>
    @hoverable = false
    @hide()
    
  hideAndSetIdleOn: () =>
    @hide()
    @setIdleOn()
    
  setHoverable: () =>
    @hoverable = true
    
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