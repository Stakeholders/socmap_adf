ADF.Map.Views.Tooltip ||= {}

class ADF.Map.Views.Tooltip.Text extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/map/templates/tooltip/text']
  
  offset_left: 5
  offset_top: 0
  text: ""
  active: false
  
  initialize: =>
    @map = @options.map
    @containerArea = @options.containerArea
  
  render: () ->
    newElement = @make("div", {"class": "show_tip", "id" : "map_ballon", "style" : "display:none;position:absolute;"} )
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
    left = e.pageX + @offset_left
    top = e.pageY + @offset_top
    @$el.css("top", top+"px").css("left", left+"px")

  setText: ( text ) ->
    if not @active
      @active = true
      $(@containerArea).bind "mouseover", @show
      $(@containerArea).bind "mouseleave", @hide
      $(@containerArea).bind "mousemove", @move
    
    @$("span").html(text)