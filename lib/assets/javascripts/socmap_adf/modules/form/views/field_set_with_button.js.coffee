class ADF.Form.Views.FieldSetWithButton extends ADF.Form.Views.FieldSet

  fieldSetButton: JST['socmap_adf/modules/form/templates/field_set_button']

  constructor: (options) ->
    super(options)
    @buttonTitle = options.buttonTitle

  render: () ->
    $(@el).html(@tabSetContainer())
    @$(".tab_set_content").html(@template( @model.toJSON() ))
    @$(".tab_set_content").append(@fieldSetButton)
    @$(".field_wrap_all").hide() 
    @$(".tab_title").text(@title)
    @$(".btn_input input").val(@buttonTitle) if @buttonTitle?
    @bindFieldTab()
    @bindButton()
    @onBind()
    @

  bindButton: () ->
    @$(".btn_input input").bind "mousedown", @onInputClicked

  onDataValid: () ->
    @$(".btn_input").removeClass("grey")
    @$(".btn_input").addClass("green")
    @$(".btn_input").find("input").removeAttr("disabled")
    @hideError()

  onDataInvalid: () ->
    @$(".btn_input").removeClass("green")
    @$(".btn_input").addClass("grey")
    @$(".btn_input").find("input").attr("disabled", "disabled")

  onInputClicked: () =>
    @hideError()
    if @model.isValid()
      @openNextFieldSet()