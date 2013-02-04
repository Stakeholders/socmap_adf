ADF.Login.Views.Popup ||= {}

class ADF.Login.Views.Popup.Main extends ADF.Popup.Views.Base

  template: JST['socmap_adf/modules/login/templates/popup/main']
  popupClass: "login_popup_wrap"
  hasBacground: true
  closable: false

  events:
    "click .close" : "closeClicked"
  
  initialize: () ->
    @model = @options.instance
    @onLoginDone = @options.onLoginDone if typeof( @options.onLoginDone ) == "function"
    
    @eventBus.bind "loginDone", @onLoginClosed
    @bootstrap()
  
  bootstrap: () ->
    @emailForm = new ADF.Login.Models.EmailForm({})
    
    @loginView = new ADF.Login.Views.Partial.Login
      popupView: @
      instance: @model
      emailForm: @emailForm
      
    @resetPasswordView = new ADF.Login.Views.Partial.Reset
      popupView: @
      instance: @model
      emailForm: @emailForm
     
  onRenderCompleted: () =>
    @renderLoginView()
  
  renderLoginView: () =>
    @setContent @loginView 
    
  renderPasswordResetView: () =>
    @setContent @resetPasswordView 
   
  setContent: (view) =>
    @$(".login_content_wrap").html( view.render().el )
    @center()
    
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
    
