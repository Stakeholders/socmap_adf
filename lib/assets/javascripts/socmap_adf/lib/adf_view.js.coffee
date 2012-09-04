class ADF.View extends Backbone.View
  
  render: ->
    @$(@el).unbind()
    @el = @template
    @delegateEvents()
    return this