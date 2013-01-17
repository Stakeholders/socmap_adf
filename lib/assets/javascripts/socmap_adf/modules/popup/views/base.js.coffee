class ADF.Popup.Views.Base extends ADF.MVC.Views.Base
 
  popupContainer: JST['socmap_adf/modules/popup/templates/basic']
  popupContentClass: ".mapfield_padding"
  popupClass: "popup_wrap"
  popupBacgroundClass: "popup_background"
  hasBacground: true
  closable: true
  horizontalAlign: "center"
  verticalAlign: "center"
  horizontalOffset: 0
  verticalOffset: 0
  category: "other"
  autoHeight: false
  
  render: () ->
    newElement = @make("div", {"class": @popupClass})
    @.setElement(newElement)
    $(@el).html(@popupContainer)
    if @model
      @$(@popupContentClass).html(@template(@model.toJSON()))
    else 
      @$(@popupContentClass).html(@template)
    @bindCloseButton()

    $("body").append(@make("div", {"id": "popups"})) if !$("#popups").length

    if @category
      if !$("#popups").find("#" + @category + "_popups").length
        $("#popups").append(@make("div", {"id": @category + "_popups"}))
      $("#" + @category + "_popups").append(@el)
    else
      $("#popups").append(@el)
     
    @addBacground() if @hasBacground
    @center()
    $(window).bind "resize", @center
    @onBind()
    @onRenderCompleted()
    return @

  addBacground: () ->
    if !@bacground
      @bacground = @make("div", {"class": @popupBacgroundClass})
    $("#popups").append(@bacground)
    $("." + @popupBacgroundClass).bind "click", @closeButtonClicked if @closable
    
  bindCloseButton: () ->
    if @closable
      @$(".btn_close").bind "click", @closeButtonClicked
    else 
      @$(".btn_close").remove()

  closeButtonClicked: (e) =>
    e.preventDefault()
    @destroy()

  center: () =>
    windowHeight = $(window).height()
    windowWidth = $(window).width()
    elHeight = $(@el).height()
    elWidth = $(@el).width()

    if @verticalAlign == "top"
      top = 10 + @verticalOffset
    else if @verticalAlign == "bottom"
      top =  windowHeight - 10 - elHeight - @verticalOffset
    else
      offsetTop = ((elHeight + @verticalOffset) / 2)
      top =  windowHeight / 2
      top = top - offsetTop

    if @horizontalAlign == "left"
      left = 10 + @horizontalOffset
    else if @horizontalAlign == "right"
      left = windowWidth - elWidth - 10 - @horizontalOffset
    else   
      left = (windowWidth + @horizontalOffset) / 2
      offsetLeft = (elWidth / 2)
      left = left - offsetLeft

    
    $(@el).css({height: ($(window).height() - top) + "px" }) if @autoHeight
    $(@el).css({top: top, left: left})

  open: () ->
    $(@el).show()

  close: () ->
    $(@el).hide()
    $("." + @popupBacgroundClass).hide() if @hasBacground

  destroy: () ->
    @beforeDestroy()
    $(@el).remove()
    $(@bacground).remove() if @hasBacground

  onBind: () ->
  onRenderCompleted: () ->
  beforeDestroy: () ->