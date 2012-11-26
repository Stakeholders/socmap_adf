class ADF.Map.Views.PolygonLabel extends ADF.Overlay.Views.FlashOverlay
  
  template: JST['socmap_adf/modules/overlay/templates/polygon_label']
  dontRenderMarker: true
  mouseout: false
  hoverable: false
  label: ""
  
  initialize: () ->
    super()
    @label = @options.label if @options.label
    @content = @options.content
    @template = @options.template if @options.template
    @customMarker = new ADF.Zone.Views.LabelMarker()
    @labelClass = "marker_label hover" if @content 
    
  setContent: (content) ->
    @content = content
  
  render: ->
    $(@el).html( @template() )
    @onRenderCompleted()
    @initResize()
    @redraw()
    @onRenderCompleted()
    @
    
  onRenderCompleted: () ->
    @$(".content").html(@content)
    $(@el).hover(@openOverlayOnHover, @hideOverlayAfterTime)
    invisible = if @label.length > 0 then "" else " invisible" 
    if @content && @marker.label?
      @marker.set("labelClass", "marker_label hover#{invisible}")
    else if @marker.label 
      @marker.set("labelClass", "marker_label#{invisible}")

      
  onOverlayShowed: () =>
    @_setScrollable()

  _setScrollable: () =>
    @$(".scrollable").nanoScroller({autoresize: true})