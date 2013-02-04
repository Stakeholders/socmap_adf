ADF.Login.Views.Partial ||= {}

class ADF.Login.Views.Partial.Reset extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/login/templates/partial/reset']
  events:
    "click .back" : "onBackClicked"
    "click input[name=reset]" : "onResetPasswordClicked"
  
  initialize: () ->
    @popupView = @options.popupView
    @emailForm = @options.emailForm
    
  render: () =>
    @$el.html( @template( @emailForm.toJSON() ) )
    @delegateEvents()
    @emailForm.bindValue("email", { success: @onEmailValidationSuccess, error: @onEmailValidationError} ).to(@$("input[name=email]"))
    if @emailForm.id
      @renderSuccess()
    else
      setTimeout ( => @$("input[name=email]").focus() ), 1
    @
    
  renderSuccess: () =>
    @$(".textarea_wrap").hide()
    @$(".btn_input").hide()
    @$(".back").text( I18n.t("socmap_adf.login.password_reset_home_button") )
    @$(".description").text( I18n.t("socmap_adf.login.password_reser_desc_success") )
    @popupView.center()
    
  onBackClicked: (e) =>
    e.preventDefault()
    @popupView.renderLoginView()
    
  onResetPasswordClicked: (e) =>
    e.preventDefault()
    @emailForm.resetEmail( @onEmailResat )
    @onDataInvalid()
    @$(".btn_input").addClass("loading")
    
  onEmailResat: () =>
    @renderSuccess()
  
  onEmailValidationSuccess: () =>
    @emailForm.checkEmailRegistred( @onEmailValid )
    
  onEmailValid: ( email ) =>
    if email.registred() && !email.hasProvider()
      @$(".login_email").text( "" )
      @onDataValid()
    else
      @$(".login_email").text( I18n.t("socmap_adf.login.unexisted_email_error") )
      @onDataInvalid()
    
  onEmailValidationError: () =>
    @onDataInvalid()
        
  onDataValid: () ->
    @$(".btn_input").removeClass("grey")
    @$(".btn_input").addClass("green")
    @$(".btn_input").find("input").removeAttr("disabled")

  onDataInvalid: () ->
    @$(".btn_input").removeClass("green")
    @$(".btn_input").addClass("grey")
    @$(".btn_input").find("input").attr("disabled", "disabled")