class ADF.Form.Views.Base extends ADF.MVC.Views.Base

  constructor: (options) ->
    super(options)
    @model.setView(@) if @model

  # Callbacks
  onDataValid: () ->
  onDataInvalid: () ->