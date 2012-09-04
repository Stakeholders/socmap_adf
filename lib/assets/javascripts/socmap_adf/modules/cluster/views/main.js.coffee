class ADF.Cluster.Views.Main extends ADF.MVC.Views.Base
   
  initialize: ->
    _.bindAll(this, 'render')
    
  render: ->
    @onRenderComplete()   
    return @

  onRenderComplete: () =>