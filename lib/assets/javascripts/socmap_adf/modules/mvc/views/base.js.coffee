class ADF.MVC.Views.Base extends Backbone.View

  constructor: (options) ->
    @eventBus = window.eventBus
    super(options)