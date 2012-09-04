class ADF.Form.Views.FieldSet extends ADF.Form.Views.Base
  
  tabSetContainer: JST['socmap_adf/modules/form/templates/field_set']
  title: " - "
  index: 0

  constructor: (options) ->
    super(options)
    @done = false
    @expanded = false
    @changeToClose()

    @fieldSetsObject = null
    options.model.setView(@) if options.model
    if options.closed == false
      @changeToOpen()

  render: () ->
    $(@el).html(@tabSetContainer)
    @$(".tab_set_content").html(@template(@model.toJSON()))
    @$(".field_wrap_all").hide() 
    @$(".tab_title").text(@title)
    @bindFieldTab()
    @onBind()
    return this

  getIndex: () ->
    @index

  setIndex: (index) ->
    @index = index

  bindFieldTab: () ->
    @$(".tab_wrap").bind "click", @onTabClicked

  onTabClicked: () =>
    if @expanded
      @contract()
    else
      @expand()

  setFieldSetsObject: (obj) =>
    @fieldSetsObject = obj

  expand: () =>
    if !@closed
      @expanded = true
      @fieldSetsObject.onFieldSetExpand(@)
      @$(".field_wrap_all").slideDown("normal", @onExpand)
      @$(".tab_wrap_all").addClass("open")

  changeToOpen: () ->
    @closed = false
    @$(".tab_wrap").css("cursor", "pointer")

  changeToClose: () ->
    @closed = true
    @$(".tab_wrap").css("cursor", "default")

  contract: () =>
    @$(".field_wrap_all").slideUp()
    @expanded = false
    @$(".tab_wrap_all").removeClass("open")
    @onContract()
        
  openNextFieldSet: () ->
    @setDone()
    @fieldSetsObject.openNextFieldSet()

  setDone: () =>
    @done = true
    @onDone()
    @$(".tab_wrap_all").addClass("done")

  getModel: () ->
    @model

  showError: (message) ->
    @fieldSetsObject.showError(message) if @fieldSetsObject

  hideError: () ->
    @fieldSetsObject.hideError() if @fieldSetsObject
    
  # Callbacks
  onDone: () ->
  onBind: () ->
  onExpand: () ->
  onContract: () ->