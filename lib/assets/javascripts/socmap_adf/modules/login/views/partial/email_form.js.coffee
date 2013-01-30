ADF.Login.Views.Partial ||= {}

class ADF.Login.Views.Partial.EmailForm extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/login/templates/partial/email_form']
  registrationFormShowed: false
  loginFormShowed: false
  
  initialize: () ->
    @popupView = @options.popupView
    @onEmailValid = @options.onEmailValid if typeof( @options.onEmailValid ) == "function"
    @onEmailInvalid = @options.onEmailInvalid if typeof( @options.onEmailInvalid ) == "function"

    @model = new ADF.Login.Models.EmailForm({})
    @loginForm = new ADF.Login.Models.LoginForm({})
    @registrationForm = new ADF.Login.Models.RegistrationForm({})

    @model.setView(@)
    @loginForm.setView(@)
    @registrationForm.setView(@)
    
  render: () ->
    $(@el).html(@template())
    
    @model.bindValue("email", { success: @onEmailValidationSuccess, error: @onEmailValidationError} ).to(@$("input[name=email]"))
    @expandClickableArea()
    @popupView.center()
    @
  
  onLoginClicked: () =>
    @loginForm.set( "email", @$("input[name=email]").val())
    @loginForm.set( "password", @$("input[name=password_l]").val())
    @loginForm.save( null, { 
      success : @onLoginSaved
      error: @onFaild
    })
    _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Mēģina logoties'])
    return false

  onRegisterClicked: () =>
    @registrationForm.set( "first_name", @$("input[name=first_name]").val())
    @registrationForm.set( "last_name", @$("input[name=last_name]").val())
    @registrationForm.set( "email", @$("input[name=email]").val())
    @registrationForm.set( "password", @$("input[name=password_r]").val())
    @registrationForm.set( "password_confirmation", @$("input[name=password_confirmation]").val())
    @registrationForm.save( null, { 
      success : @onRegistrationSaved
      error: @onFaildRegister
    })
    _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Mēģina reģistrēties' ])
    return false
      
  onLoginSaved: () =>
    @eventBus.trigger "loginDone"
    _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Ielogojas' ])

  onRegistrationSaved: () =>
    @eventBus.trigger "loginDone"
    _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Piereģistrējas'])
      
  onFaild: () =>
    alert I18n.t("socmap_adf.login.login_error")
    _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Nepareiza parole'])
    
  onFaildRegister: (data) =>
    alert I18n.t("socmap_adf.login.cannot_register_email")
    _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Nevar ielogoties/piereģistrēties (konts ir FB)' ])
  
  showRegistrationForm: () ->
    $(".registration_form").show()
    @registrationForm.bindValue("email").to(@$("input[name=email]"))
    @registrationForm.bindValue("first_name").to(@$("input[name=first_name]"))
    @registrationForm.bindValue("last_name").to(@$("input[name=last_name]"))
    @registrationForm.bindValue("password").to(@$("input[name=password_r]"))
    @registrationForm.bindValue("password_confirmation").to(@$("input[name=password_confirmation]"))
    @registrationForm.validateModel()
    
    @$("input[name=register]").unbind().click @onRegisterClicked
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
    @enableTabForInput( @$("input[name=email]") )
    if email.registred()
      @hideRegistrationForm()
      @showLoginForm()
      _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Sāk logoties'])
    else
      @hideLoginForm()
      @showRegistrationForm()
      _gaq.push(['_trackEvent', 'Logošanās', 'Email', 'Sāk reģistrēties'])
    @popupView.center()
      
    
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
