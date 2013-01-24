class ADF.Sidebar.Views.Tabcontent extends ADF.MVC.Views.Base
  
  initialize: ->
        
  render: ->
    el = $("<div>", {"class": "content"})
    @setElement(el)
    $(@el).html(@template)
    @onRenderComplete()
    @
    
    
  onRenderComplete: ->
    
  showLoading: ( waitLoading ) ->
    @waitLoading = waitLoading
    @loading = $("<img>", {"src":"/assets/small_loading_gray.gif", "class":"tab_loading"})
    @$el.prepend(@loading)
    
  hideLoading: ()->
    @waitLoading = @waitLoading - 1
    $(@loading).remove() if @waitLoading <= 0
    