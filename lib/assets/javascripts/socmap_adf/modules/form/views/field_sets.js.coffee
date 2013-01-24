class ADF.Form.Views.FieldSets extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/form/templates/field_sets']
  errorTemplate: JST['socmap_adf/modules/form/templates/error_field']
  
  constructor: (options) ->
    super(options)
    @current = 0
    @count = 0
    @fieldSets = []
    @done = false

  render: () ->
    $(@el).html(@template)
    @onBind()
    @checkFieldSets()
    @openFieldSet(0)
    @addErrorField()
    return this

  showError: (message) ->
    @$(".error_message").html(message)
    @$(".error_placeholder").show()

  hideError: () ->
    @$(".error_placeholder").hide()
  
  addErrorField: () ->
    @$(".form_tabs").append(@errorTemplate)

  addFieldSet: (fieldSet) ->
    fieldSet.setFieldSetsObject(@)
    fieldSet.setElement($("<li>"))
    fieldSet.setIndex(@count)
    @fieldSets.push(fieldSet)
    @$(".form_tabs").append(fieldSet.render().el)
    @count++

  checkFieldSets: () ->
    for fieldSet in @fieldSets
      if fieldSet.getModel().validateFields()
        fieldSet.changeToOpen()
        fieldSet.setDone()
        @checkDone()
        
      else
        break
    # @openFieldSet(@current)
    
  openFieldSet: (index) ->
    @current = index
    fieldSet = @fieldSets[index]
    if fieldSet
      fieldSet.getModel().validateFields()
      fieldSet.changeToOpen()
      fieldSet.expand()

  checkDone: () ->
    if @current + 1 < @fieldSets.length
      @current++
    else
      @setDone()

  openNextFieldSet: () ->
    @checkDone()
    @openFieldSet @current

  onFieldSetExpand: (expandFieldSet) ->
    current = expandFieldSet
    @current = current.getIndex()
    for fieldSet in @fieldSets
      if fieldSet != expandFieldSet
        fieldSet.contract()

  setDone: () ->
    @done = true
    @onDone()
    
  # Callbacks
  onBind: () ->
  onDone: () ->