ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Flash extends ADF.Map.Views.Overlay.Content.Abstract
  
  constructor: (options) ->
    super(options)

  onMarkerMouseOver: () =>
    @show()

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