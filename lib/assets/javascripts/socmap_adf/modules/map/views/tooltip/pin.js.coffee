ADF.Map.Views.Tooltip ||= {}

class ADF.Map.Views.Tooltip.Pin extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/map/templates/tooltip/pin']
  offset_left: 0
  offset_top: -91
  
  initialize: =>
    @map = @options.map
    @containerArea = @options.containerArea
    @label = @options.label
    @pin = @options.pin
    @color = @options.color
    @setActive()
  
  render: () ->
    @setElement( @make("div", {"class":"mapitem_block", "style" : "display:none;"}) )
    @$el.html(@template({color: @color, label: @label, pin: @pin }))
    @

  setInactive: () ->
    $(@containerArea).unbind "mouseover"
    $(@containerArea).unbind "mouseout"
    $(@containerArea).unbind "mousemove"
    @remove()
    
  movingPinHeight: () ->
    @$el.height()
    
  remove: (e) =>
    @$el.remove()

  show: (e) =>
    @$el.show()

  hide: (e) =>
    @$el.hide()     

  move: (e) =>
    left = e.pageX + @offset_left - (@$el.width() / 2)
    top = e.pageY + @offset_top - @movingPinHeight()
    @$el.css("top", top+"px").css("left", left+"px")

  setActive: () ->
    $(@containerArea).bind "mouseover", @show
    $(@containerArea).bind "mouseleave", @hide
    $(@containerArea).bind "mousemove", @move
    $(@containerArea).trigger("mousemove")