class ADF.Sidebar.Views.Tab extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/sidebar/templates/tab']
  
  title: ""
  url: ""
  selected: false
  tabsObject : null
  content: null
  events :
    "click a.tablink" : "click"
  
      
  initialize: ->
    _.bindAll(this, 'render')
    @eventBus = @options.eventBus
  
  render: ->
    $(@el).html(@template)
    @$("a.tablink").html(@title)
    @$("a.tablink").attr("href", @url)
    @onRenderTabComplete()
    return @
    
  select: ->
    @$("a.tablink").addClass("active")
    @tabsObject.renderContent(@)
    @tabsObject.setBottomLinks( @bottomlinks )
    @onSelectComplete()
    
  deselect: ->
    @$("a.tablink").removeClass("active")
    
  click: (e) ->
    e.preventDefault()
    window.mainRouter.navigate(@url(), {trigger: false});
    @tabsObject.selectTab(@)
    
  setTabsObject: (obj) ->
    @tabsObject = obj
    
  addTabBottomLink: ( bootomlink ) =>
    @bottomlinks = [] if not @bottomlinks
    @bottomlinks.push( bootomlink )
  
  initBottomLinks: () ->
           
  # Callbacks  
  onRenderComplete: ->
  onRenderTabComplete: ->
  onSelectComplete: ->
    