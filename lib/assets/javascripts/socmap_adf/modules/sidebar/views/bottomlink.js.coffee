class ADF.Sidebar.Views.Bottomlink extends ADF.MVC.Views.Base
  
  template: JST["socmap_adf/modules/sidebar/templates/bottomlink"]
  templateaction : JST["socmap_adf/modules/sidebar/templates/bottomlinkaction"]
  
  title: ""
  aclass: ""
  withaction: false
  actiontitle: ""
  height: 30
  events :
    "click a" : "click"
  
  initialize: ->
    _.bindAll(this, 'render')
    @eventBus = @options.eventBus
    
  render: ->
    el = @make("li")
    @setElement(el)
    if @withaction then @renderWithAction() else @renderWithoutAction()
    @onRenderComplete()   
    return @
      
  renderWithAction: () ->
    $(@el).html(@templateaction)
    @$("span").attr("class", @aclass) 
      
  renderWithoutAction: () ->    
    $(@el).html(@template)
    @$("a").html(@title)
    @$("a").attr("class", @aclass)   
  
  click: (e) ->
    e.preventDefault()
    @onClicked(e)
    
  # CALLBACKS
  onClicked: (e) ->
  onRenderComplete:() ->      
  