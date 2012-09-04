class ADF.Minimap.Views.Tooltip extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/minimap/templates/tooltip']
  
  offset_left: 5
  offset_top: 0
  text: ""
  active: false
  
  initialize: =>
    @map = @options.map
    @containerArea = @options.containerArea
  
  render: () ->
    newElement = @make("div", {"class": "show_tip", "id" : "minimap_ballon", "style" : "display:none;position:absolute;"} )
    @setElement( newElement )
    @$el.html( @template )
    @

  setInactive: () ->
    @active = false
    $(@containerArea).unbind "mouseover"
    $(@containerArea).unbind "mouseout"
    $(@containerArea).unbind "mousemove"
    @hide()
    
  show: (e) =>
    @move(e)
    @$el.show()

  hide: (e) =>
    @$el.hide()

  move: (e) =>
    parentOffset = @$el.parent().offset()
    left = e.pageX - parentOffset.left + @offset_left
    top = e.pageY - parentOffset.top + @offset_top
    @$el.css("top", top+"px").css("left", left+"px")

  setText: ( text ) ->
    if not @active
      @active = true
      $(@containerArea).bind "mouseover", @show
      $(@containerArea).bind "mouseleave", @hide
      $(@containerArea).bind "mousemove", @move
    
    @$("span").html(text)