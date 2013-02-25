ADF.Login.Views.Partial ||= {}

class ADF.Login.Views.Partial.Login extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/login/templates/partial/login']
  
  facebookLoginUrl: "/authorizme/login/facebook"
  
  events:
    "click .facebook" : "loginFacebook"

  initialize: () ->
    @popupView = @options.popupView
    @emailForm = @options.emailForm
    @hasNameField = @options.hasNameField

    @emailFormView = new ADF.Login.Views.Partial.EmailForm
      popupView: @popupView
      emailForm: @emailForm
      hasNameField: @hasNameField

  render: () =>
    @$el.html( @template() )
    @$(".email_login_wrap").html( @emailFormView.render().el )
    @delegateEvents()
    @

  loginFacebook: (e) =>
    e.preventDefault()
    window.open(@facebookLoginUrl, 'authorization_popup', 'toolbar=0,menubar=0,width=640,height=500,scrollbars=0')
    @eventBus.trigger "ADF.Login.Views.Partial.Login.StartFacebookLogin"
    return false