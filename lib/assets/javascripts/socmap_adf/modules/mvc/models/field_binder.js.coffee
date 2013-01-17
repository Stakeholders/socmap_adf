class ADF.MVC.Models.FieldBinder
  
  model: null
  field: null
  attribute: null
  isTyping: false
  timeout: null
    
  constructor: (model, attribute, options) ->
    @model = model
    @attribute = attribute
    @model.on "change", @onValueChanged
    @markChecks = options.markChecks
    @bindFocus = options.bindFocus
    @onFieldSuccess = options.success if typeof( options.success ) == "function"
    @onFieldError = options.error if typeof( options.error ) == "function"
    
  to: (field) ->
    @field = field
    @bindField()
    
  bindField: () ->
    $(@field).bind "keyup", @typing
    $(@field).bind "change", @valueChanged
    $(@field).bind "focus", @onFocus if @bindFocus
    $(@field).bind "blur", @hideMessages

  typing: (e) =>
    clearTimeout(@timeout)
    @isTyping = true
    self = @
    @timeout = setTimeout( () =>
      @isTyping = false
      @valueChanged(e)
    500)

  valueChanged: (e) =>
    @model.set(@attribute, e.delegateTarget.value)
    if !@isTyping
      if @model.hasError(@attribute)
        @hideSuccess()
        @showError() 
      else 
        @hideError()
        @showSuccess()

  onFocus: (e) =>
    if @model.getErrorByType(@attribute, "present") != null
      @hideError()
    else
      @valueChanged(e)

  hideMessages: () =>
    @hideSuccess(true)
    @hideError()

  markCorrect: () ->
    $(@field).parent().addClass("checked")
    @onFieldSuccess()
    
  unmarkCorrect: () ->
    $(@field).parent().removeClass("checked")
    @onFieldError()
    
  showError: () ->
    errorField = $(@field).parent().find(".error_message")
    label = $(@field).parent().find("label")
    if errorField
      error = @model.getError(@attribute)
      errorField.html(error.message)
      errorField.fadeIn("fast")
    if label
      label.removeClass("done")
      label.addClass("error")

  hideError: () ->
    errorField = $(@field).parent().find(".error_message")
    label = $(@field).parent().find("label")
    if errorField
      errorField.html("")
      errorField.hide()
    if label
      label.removeClass("error")

  showSuccess: () ->
    successField = $(@field).parent().find(".success_message")
    label = $(@field).parent().find("label")
    if successField
      successField.fadeIn("slow")
    if label
      label.addClass("done")
      @markCorrect() if @markChecks
    
  hideSuccess: (withFade = false) ->
    successField = $(@field).parent().find(".success_message")
    if successField
      if withFade
        successField.fadeOut("slow")
      else
        successField.hide()
        @unmarkCorrect() if @markChecks
        
  onFieldSuccess: () ->
  onFieldError: () ->