class ADF.Sidebar.Views.Content extends ADF.MVC.Views.Base
  
  top: 39
  bottomlinkheight: 32
  contentTemplate: JST["socmap_adf/modules/sidebar/templates/content"]
  
  constructor: ( options ) ->
    super(options)
    @doNanoScroll =  if options.doNanoScroll? then options.doNanoScroll else true
    @model = @options.model
    @rendered = false
    
  render: ->
    $(@el).html(@contentTemplate) 
    template = if @model then @template( @model.toJSON() ) else @template()
    @$(".level_content_wrap").html(template)
    @renderBottomLinks()
    @bindResize() 
    @onRenderComplete()
    @calculateResize()
    @initNanoScroller() if @doNanoScroll
    @rendered = true
    return @
    
  bindResize: ->
    $(window).bind "resize", @calculateResize

  calculateResize: () =>
    height = $(window).height() - @top - @bottomlinkheight * @countBottomLinks()
    @$(".level_content_wrap").css({ "height" : height + "px"})

  initNanoScroller: () ->
    setTimeout(
      => @$(".level_content_wrap").nanoScroller({autoresize: true}),
      300
    )
  
  setBottomLinks: (bottomlinks) =>
    @bottomlinks = bottomlinks
    @renderBottomLinks()
    @onBottomLinksSat()
           
  addBottomLink: ( bootomlink ) =>
    @bottomlinks = [] if not @bottomlinks
    @bottomlinks.push( bootomlink )

  countBottomLinks: ->
    if @bottomlinks? then @bottomlinks.length else 0
          
  renderBottomLinks: ->
    @$(".panel_buttons").html("")
    return false if not @bottomlinks
    @$(".panel_buttons").append(bottomLink.render().el) for bottomLink in @bottomlinks

  addLoading: ->
    $(@el).prepend('<div class="sidebar_loading"><div class="loader"><img src="/assets/load.gif" alt="" width="31" height="31" /></div><div class="overlay"></div></div>')

  removeLoading: ->
    $(@el).find('.sidebar_loading').remove()

  # CALLBACKS  
  onRenderComplete: ->
  onBottomLinksSat: ->