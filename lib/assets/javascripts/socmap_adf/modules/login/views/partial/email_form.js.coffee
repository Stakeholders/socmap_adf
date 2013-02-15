ADF.Login.Views.Partial ||= {}

class ADF.Login.Views.Partial.EmailForm extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/login/templates/partial/email_form']
  registrationFormShowed: false
  loginFormShowed: false
  
  initialize: () ->
    @popupView = @options.popupView  
    @onEmailValid = @options.onEmailValid if typeof( @options.onEmailValid ) == "function"
    @onEmailInvalid = @options.onEmailInvalid if typeof( @options.onEmailInvalid ) == "function"

    @model = @options.emailForm
    @loginForm = new ADF.Login.Models.LoginForm({})
    @registrationForm = new ADF.Login.Models.RegistrationForm({})

    @model.setView(@)
    @loginForm.setView(@)
    @registrationForm.setView(@)
    
  render: () ->
    $(@el).html(@template( @model.toJSON() ))
    
    @model.bindValue("email", { success: @onEmailValidationSuccess, error: @onEmailValidationError} ).to(@$("input[name=email]"))
    @expandClickableArea()
    setTimeout ( => @$("input[name=email]").focus() ), 1
    
    @
  
  onLoginClicked: () =>
    @loginForm.set( "email", @$("input[name=email]").val())
    @loginForm.set( "password", @$("input[name=password_l]").val())
    @loginForm.save( null, { 
      success : @onLoginSaved
      error: @onFaild
    })
    @eventBus.trigger "ADF.Login.Views.EmailForm.TryLogin"
    return false
  
  onPasswordResetClicked: (e) =>
    e.preventDefault()
    @popupView.renderPasswordResetView()
    
  onRegisterClicked: () =>
    @registrationForm.set( "first_name", @$("input[name=first_name]").val())
    @registrationForm.set( "email", @$("input[name=email]").val())
    @registrationForm.set( "password", @$("input[name=password_r]").val())
    @registrationForm.set( "password_confirmation", @$("input[name=password_confirmation]").val())
    @registrationForm.save( null, { 
      success : @onRegistrationSaved
      error: @onFaildRegister
    })
    @eventBus.trigger "ADF.Login.Views.EmailForm.TrySignup"
    return false
    
  onTermsClicked: (e) =>
    e.preventDefault()
    window.open("/adf/terms/index", '', 'toolbar=0,menubar=0,width=640,height=500')
      
  onLoginSaved: () =>
    @eventBus.trigger "loginDone"
    @eventBus.trigger "ADF.Login.Views.EmailForm.LoginDone"

  onRegistrationSaved: () =>
    @eventBus.trigger "loginDone"
    @eventBus.trigger "ADF.Login.Views.EmailForm.RegisterDone"
      
  onFaild: () =>
    @$(".login_password").text(I18n.t("socmap_adf.login.error.authorization")).show()
    @eventBus.trigger "ADF.Login.Views.EmailForm.WrongPassword"
    
  onFaildRegister: (data) =>
    @eventBus.trigger "ADF.Login.Views.EmailForm.RegistrationFailed"
  
  showRegistrationForm: () ->
    $(".registration_form").show()
    @registrationForm.bindValue("email").to(@$("input[name=email]"))
    @registrationForm.bindValue("first_name").to(@$("input[name=first_name]"))
    @registrationForm.bindValue("password").to(@$("input[name=password_r]"))
    @registrationForm.bindValue("password_confirmation").to(@$("input[name=password_confirmation]"))
    @registrationForm.validateModel()
    
    @$("input[name=register]").unbind().click @onRegisterClicked
    @$(".terms").unbind().click @onTermsClicked
    @expandClickableArea("login") unless @registrationFormShowed
    @registrationFormShowed = true
    
  hideRegistrationForm: () ->
    $(".registration_form").hide()
    
  showLoginForm: () ->
    @$(".login_form").show()
    @loginForm.bindValue("email").to(@$("input[name=email]"))
    @loginForm.bindValue("password").to(@$("input[name=password_l]"))
    @loginForm.validateModel()
    
    @$("input[name=login]").unbind().click @onLoginClicked
    @$(".forgot_password").unbind().click @onPasswordResetClicked
    @expandClickableArea("registration")  unless @loginFormShowed
    @loginFormShowed = true
    
    
  hideLoginForm: () ->
    @$(".login_form").hide()
  
  onEmailValidationSuccess: () =>
    @model.checkEmailRegistred( @onEmailValid )
    
  onEmailValidationError: () =>
    @onEmailInvalid()
  
  onDataValid: () ->
    if @loginForm.isValid() || @registrationForm.isValid()
      @$(".btn_input").removeClass("grey")
      @$(".btn_input").addClass("green")
      @$(".btn_input").find("input").removeAttr("disabled")

  onDataInvalid: () ->
    @$(".btn_input").removeClass("green")
    @$(".btn_input").addClass("grey")
    @$(".btn_input").find("input").attr("disabled", "disabled")
    @onEmailInvalid( @model ) unless @model.isValid()
    
  onEmailValid: ( email ) =>
    unless email.hasProvider()
      @$(".login_email").text("")
      @enableTabForInput( @$("input[name=email]") )
      if email.registred()
        @hideRegistrationForm()
        @showLoginForm()
        @eventBus.trigger "ADF.Login.Views.EmailForm.StartLoging"
      else
        @hideLoginForm()
        @showRegistrationForm()
        @eventBus.trigger "ADF.Login.Views.EmailForm.StartSignup"
      @popupView.center()
    else
      @onEmailInvalid()
      @$(".login_email").text( I18n.t("socmap_adf.login.error.cannot_register_email", {provider: email.get("provider")}) )
      
  onEmailInvalid: () ->
    @disableTabForInput( @$("input[name=email]") )
    @hideLoginForm()
    @hideRegistrationForm()
    @popupView.center()
    
  disableTabForInput: ( input ) ->
    input.on 'keydown', ( e) =>
      e.preventDefault() if e.keyCode == 9 || e.which == 9

  enableTabForInput: ( input ) ->
    input.off "keydown"
    
    
  expandClickableArea: ( className = "") ->
    @$(".textarea_wrap" + className).find("input").defaultValue()
    #@$(".textarea_wrap" + className).click( (e) -> $(e.currentTarget).find("input").focus() ).css("cursor", "text")
