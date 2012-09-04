class ADF.Minimap.Views.MovingPin extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/minimap/templates/moving_pin']
  offset_left: 0
  offset_top: -91
  label: ""
  offsetElement: {offset: ->
    left: 0
    right: 0}
  
  initialize: =>
    @map = @options.map
    @containerArea = @options.containerArea
    @label = @options.label if @options.label
    @pin = @options.pin
    @color = @options.color
    @offsetElement = @options.offsetElement if @options.offsetElement
    @offset_top = @options.offset_top if @options.offset_top?
    
  render: () ->
    @setElement( @make("div", {"class":"minimapitem_block", "style" : "display:none;position:absolute;"}) )
    @$el.html(@template({color: @color, label: @label, pin: @pin }))
    @setActive()
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
    parentOffset = @offsetElement.offset()
    left = e.pageX - parentOffset.left + @offset_left - (@$el.width() / 2)
    top = e.pageY - parentOffset.top + @offset_top - @movingPinHeight()

    @$el.css("top", top+"px").css("left", left+"px")

  setActive: () ->
    $(@containerArea).bind "mouseover", @show
    $(@containerArea).bind "mouseleave", @hide
    $(@containerArea).bind "mousemove", @move
    $(@containerArea).trigger("mousemove")