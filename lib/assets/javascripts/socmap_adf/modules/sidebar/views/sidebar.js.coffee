class ADF.Sidebar.Views.Sidebar extends ADF.MVC.Views.Base
  
  top: 0
  tabs: false
  hidden: false
  thirdLevelTop: 40
  top: 39
  smallSpeed: 400
  bigSpeed: 500
  firstPanelClass: "panel_4"

  template: JST["socmap_adf/modules/sidebar/templates/sidebar"]

  initialize: () ->
    _.bindAll(this, 'render', 'hideSecondLevel', 'hideThirdLevel', 'animateFirstEnterance')
    @eventBus = @options.eventBus
    @eventBus.bind("hideSecondLevel", @hideSecondLevel)
    @eventBus.bind("hideThirdLevel", @hideThirdLevel)
    @firstPanelClass = @options.firstPanelClass if @options.firstPanelClass
        
  render: -> 
    $(@el).html(@template) 
    @first_level = $(@el).find("#first_level")
    @second_level = $(@el).find("#second_level")
    @third_level = $(@el).find("#third_level")
    @delegateEvents()
    @bindResizeEvents()
    @onSidebarRendered()
    return @  

  bindResizeEvents: ->
    $(window).resize =>
      @resize()

    $(document).ready =>
      @resize()

  resize: ->
    height = $(window).height() - @top
    @first_level.css({ "top" : 0 + "px", "height" : height + "px"})
    @second_level.css({ "top" : 0 + "px", "height" : height + "px"})
    @third_level.css({ "top" : @thirdLevelTop + "px", "height" : (height - @thirdLevelTop) + "px"})

  showFirstLevel: (view) ->
    newElement = $("<div>", {"class": @firstPanelClass })
    view.setElement(newElement)
    @first_level.html(view.render().el)
    @onFirstLevelShowed()
  
  # SECOND LEVEL  
  initSecondLevel: (view) ->
    @secondView = view
    return if @secondView.rendered
    
    newElement = $("<div>", {"class": "panel_2"})
    @secondView.setElement(newElement)
    @setContent()
    @animateFirstEnterance() 
  
  setContent: () ->
    @second_level.html( @secondView.render().el )
  
  animateFirstEnterance: () ->  
    @showOverlayOverFirstColumn()
    @second_level.show()
    @second_level.animate({left: '370px'}, @bigSpeed, @onSecondLevelEntered )

  onSecondLevelEntered: =>
    @showOverlayOverFirstColumn()
    @darkenOverlayOverFirstColumn()
    @placeSecondLevel()

  placeSecondLevel: () ->
    @second_level.css({"z-index" : 9})
    @second_level.animate({left: '120px'}, @smallSpeed, @onSecondLevelPlaced )
  
  onSecondLevelPlaced: () =>
  
  closeSecondLevel: () ->
    @hideThirdLevel()
    @moveOutSecondLevel()
    @lightenOverlayOverFirstColumn()

  moveOutSecondLevel: () ->
    @second_level.animate({left: '370px', "z-index" : 3}, @smallSpeed, @onMovedOutSecondLevel )
  
  onMovedOutSecondLevel: () =>
    @second_level.animate({left: '59px'}, @smallSpeed, @onSecondLevelClosed )
    
  onSecondLevelClosed: () =>
    @second_level.hide()
    @hideOverlayOverFirstColumn()

  #Fade on first level
  showOverlayOverFirstColumn: ->
    unless @first_level.find(".first_level_overlay").is(":visible")
      @first_level.append("<div class='first_level_overlay'></div>")

  darkenOverlayOverFirstColumn: -> 
    @$(".first_level_overlay").animate({"opacity":0.5}, @smallSpeed, @onOverlayOverFirstColumnDarkened) 

  onOverlayOverFirstColumnDarkened: =>
    @$(".first_level_overlay").click (e) =>
      @$(".first_level_overlay").unbind()
      @closeSecondLevel()

  lightenOverlayOverFirstColumn: ->
    @$(".first_level_overlay").animate({"opacity":0}, @smallSpeed, @onOverlayOverFirstColumnLightened) 

  onOverlayOverFirstColumnLightened: () ->
    
    
  hideOverlayOverFirstColumn: ->
    @$("#first_level").find(".first_level_overlay").remove()
      
  # THIRD LEVEL
  initThirdLevel: (view) ->
    el = $("<div>", {"class": "panel_3"})
    view.setElement(el)
    if not @third_level.is(":visible")
      @animateFirstEnteranceThirdLevel(view)
    else
      @setContentThirdLevel(view)
  
  setContentThirdLevel: (view) ->
    @third_level.html(view.render().el)
    @addCloseButton()
      
  animateFirstEnteranceThirdLevel: (view) ->
    @setContentThirdLevel(view)
    @third_level.show()
    @third_level.css({left: '120px'})
    @third_level.animate({left: '430px'}, @bigSpeed, @onThirdLevelShowed )
  
      
  hideThirdLevel: () =>
    if @third_level.is(":visible")
      @third_level.animate({left: '120px'}, @smallSpeed, @closeThirdLevel)
   
  closeThirdLevel: () =>
    @third_level.hide()
    @third_level.html("")
    @onThirdLevelClosed()
    
  renderInnerView: ->
    @$("#slices_content").html(@view.render().el)

  addCloseButton: ->
    btn_close = $("<a>", {"class": "btn_close", "style" : "z-index:7"})
    @third_level.find(".panel_3").prepend(btn_close)
    $(btn_close).click (e) =>
      e.preventDefault()
      @hideThirdLevel()
      
  renderMenu: ->

  hideSecondLevel: ->
  # CALLBACKS
  onSidebarRendered: ->
  onFirstLevelShowed: ->        
  onThirdLevelShowed: () =>
  onThirdLevelHidden: ->
  onThirdLevelClosed: ->