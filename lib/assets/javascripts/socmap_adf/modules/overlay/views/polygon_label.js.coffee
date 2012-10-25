class ADF.Map.Views.PolygonLabel extends ADF.Overlay.Views.FlashOverlay
  
  template: JST['socmap_adf/modules/overlay/templates/polygon_label']
  dontRenderMarker: true
  mouseout: false
  hoverable: false
  
  initialize: () ->
    super()
    @label = @options.label
    @content = @options.content
    @template = @options.template if @options.template
    @customMarker = new ADF.Zone.Views.LabelMarker()
  
  render: ->
    $(@el).html( @template() )
    @onRenderCompleted()
    @initResize()
    @redraw()
    @onRenderCompleted()
    @
    
  onRenderCompleted: () ->
    @$(".content").html(@content)
    
  onOverlayShowed: () =>
    @_setScrollable()

  _setScrollable: () =>
    @$(".scrollable").nanoScroller({autoresize: true})