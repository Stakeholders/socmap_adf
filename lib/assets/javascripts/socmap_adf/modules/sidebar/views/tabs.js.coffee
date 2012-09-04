class ADF.Sidebar.Views.Tabs extends ADF.Sidebar.Views.Content
  
  template: JST['socmap_adf/modules/sidebar/templates/tabs']
  tabs_height: 41
  
  constructor: (options) ->
    options.doNanoScroll = false
    super(options)
    _.bindAll(this, 'renderTabs', 'renderContent')
    @setSelected(options.selected)
  
  setSelected: (selected) ->
    @selected = selected
  
  onRenderComplete: () ->
    @bindTabResizeEvents()
    @renderTabs()
    @resizeTabContent()

  onBottomLinksSat: ->
    @resizeTabContent()
    @initNanoScrollerForTab()
  
  renderTabs: () ->
    return false if not @tabs
    _.each(@tabs, (tab) => 
      @$("#main_menu").append(tab.render().el)
    )
      
  renderContent: (tab) ->
    @$("#tabs_content").html(tab.content.render().el)
    @initNanoScrollerForTab()
    return @  

  bindTabResizeEvents: ->
    $(window).resize => @resizeTabContent()
    
  resizeTabContent: =>
    height = $(window).height() - @tabs_height - @top - @bottomlinkheight * @countBottomLinks()
    @$("#tabs_content").css({ "height" : height + "px"})
        
  addTab: ( tab ) ->
    @tabs = [] if not @tabs
    tab.setTabsObject( @ )
    @tabs.push( tab )
    
  selectTabBySelected: ->
    @selectTab(@tabs[@selected]) if @selected? && @tabs[@selected]
    
  selectTab: (tab) ->
    return if not tab?    
    @current.deselect() if @current?
    @current = tab
    @current.select()

  initNanoScrollerForTab: ->
    setTimeout(
      => $(@el).find("#tabs_content").nanoScroller({autoresize: true}),
      1
    )
    
  # CALLBACKS  
  onTabAdded: -> 