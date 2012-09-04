class ADF.Delegate

  constructor: (klass, options) ->
    @klass = klass
    @options = options
    @view = @options.view
    @model = @options.model

  getView: () ->
    return @view

  getModel: () ->
    return @model