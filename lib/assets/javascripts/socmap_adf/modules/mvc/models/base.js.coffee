class ADF.MVC.Models.Base extends Backbone.Model

  constructor: (attributes) ->
    @correct = false
    @view = null
    @fieldBinders = []
    @errors = []
    @validations = []
    @markChecks = false
    @bindFocus = true
    super(attributes)

  setView: (view) =>
    @view = view

  bindValue: (valueName, options = {}) ->
    options.markChecks = @markChecks
    options.bindFocus = @bindFocus
    fieldBinder = new ADF.MVC.Models.FieldBinder(@, valueName, options)
    @fieldBinders.push(fieldBinder)
    fieldBinder

  # Validation
  onValueChanged: () =>
    @validateFields()
       
  validateModel: () ->
    if @isValid() && @isCustomValidationValid()
      @errors = []
      @view.onDataValid() if @view
      return true
    else
      @view.onDataInvalid() if @view
      return false
  
  validateFields: () ->
    @errors = []
    validation.validate() for validation in @validations
    @validateModel()

  isValid: () ->
    for validation in @validations
      if !validation.isValid()
        return false
    return true

  getError: (attribute) ->
    for error in @errors
      if error.attribute == attribute
        return error
    return null

  getErrorByType: (attribute, type) ->
    for error in @errors
      if error.attribute == attribute and error.type == type
        return error
    return null

  hasError: (attribute) ->
    @getError(attribute) != null

  validates: (type, attributes, options = {}) =>
    @validations.push(new ADF.MVC.Models.Validator(@, attribute, type, options)) for attribute in attributes

  clearValidations: (attributes) ->
    for attribute in attributes
      @validations = _.reject @validations, (validation) => 
        return validation.getAttribute() == attribute
    @validateFields()

  # Callbacks
  isCustomValidationValid: ->
    return true