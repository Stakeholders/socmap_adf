ADF.Login.Views.Popup ||= {}

class ADF.Login.Views.Popup.Main extends ADF.Popup.Views.Base

  template: JST['socmap_adf/modules/login/templates/popup/main']
  popupClass: "login_popup_wrap"
  hasBacground: true
  closable: false
  
  facebookLoginUrl: "/authorizme/login/facebook"
  
  events:
    "click .facebook" : "loginFacebook"
    "click .close" : "closeClicked"
  
  initialize: () ->
    @model = @options.instance
    @onLoginDone = @options.onLoginDone if typeof( @options.onLoginDone ) == "function"
    
    @eventBus.bind "loginDone", @onLoginClosed
    
    @emailFormView = new ADF.Login.Views.Partial.EmailForm
      eventBus: @eventBus
      popupView: @
  
  onRenderCompleted: () =>
    @$(".email_login_wrap").html( @emailFormView.render().el )

  loginFacebook: (e) =>
    e.preventDefault()
    window.open(@facebookLoginUrl, 'authorization_popup', 'toolbar=0,menubar=0,width=640,height=500,scrollbars=0')
    _gaq.push(['_trackEvent', 'Logošanās', 'Facebook', 'Sāk FB logošanos' ])
    return false

  closeClicked: (e) =>
    e.preventDefault()
    @onLoginCancel()
    @destroy()
    
  onLoginClosed: () =>
    @close()
    @onLoginDone()

  onLoginDone: () =>
    _gaq.push(['_trackEvent', 'Logošanās', 'Facebook', 'Pabeidz FB logošanos' ])
    
  onLoginCancel: () =>
    _gaq.push(['_trackEvent', 'Logošanās', 'Popup', 'Aizvēra ielogošanās logu' ])
    