class ADF.Map.Views.PolygonLabel extends ADF.Overlay.Views.Overlay
  
  template: JST['socmap_adf/modules/overlay/templates/polygon_label']
  dontRenderMarker: true
  
  initialize: () ->
    super()
    @label = @options.label
  
  render: ->
    $(@el).html( @template( {label: @label } ) )
    @onRenderCompleted()
    @left = 400
    @top = 45
    @initResize()
    @redraw()
    @