class ADF.Form.Models.Validator
  
  valid: false
  
  constructor: (model, attribute, validationType, options) ->
    @model = model
    @attribute = attribute
    @validationType = validationType
    @settings =
      extra: null
      message: " data not valid of " + @validationType
      size: null
    $.extend @settings, options
    @model.on "change", @onValueChanged
    
  onValueChanged: () =>
    if @model.hasChanged @attribute
      @validate()
    @model.onValueChanged()
  
  validate: () ->
    switch @validationType
      when "present" then error = @checkPresent()
      when "size" then error = @checkSize()
      when "email" then error = @checkEmail()
      when "number" then error = @checkNumber()
      when "alpha" then error = @checkAlpha()
      when "regexp" then error = @checkRegexp()
      when "confirm" then error = @checkConfirm()
    if error
      @model.errors.push new ADF.Form.Models.Error(@validationType, @settings.message, @attribute, @model.get(@attribute))
      @valid = false
    else
      @valid = true
  
  checkPresent: () ->
    !(@model.get(@attribute) && @model.get(@attribute) != null && @model.get(@attribute).toString().length > 0)
          
  checkSize: () ->
    !(@model.get(@attribute) && @model.get(@attribute) != null && @model.get(@attribute).toString().length >= @settings.size)
    
  checkConfirm: () ->
    @model.get(@attribute) != @model.get(@settings.confirm_field)
    
  checkEmail: () ->
    return false if not @model.get(@attribute)?
    reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/
    !reg.test @model.get(@attribute).toString()
  
  checkNumber: () ->
    if !isNaN(parseFloat(@model.get(@attribute))) && isFinite(@model.get(@attribute)) then false else true
    
  checkAlpha: () ->
    return false if not @model.get(@attribute)?
    reg = /[^a-zāčēģīķļņšūž ]/gi
    reg.test @model.get(@attribute).toString()

  checkRegexp:() ->  
    if @settings.regexp.test @model.get(@attribute).toString() then false else true
  
  isValid: () ->
    @valid

  getAttribute: () ->
    @attribute