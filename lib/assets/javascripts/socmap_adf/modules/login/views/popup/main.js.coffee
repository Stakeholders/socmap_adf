ADF.Login.Views.Popup ||= {}

class ADF.Login.Views.Popup.Main extends ADF.Popup.Views.Base

  template: JST['socmap_adf/modules/login/templates/popup/main']
  popupClass: "login_popup_wrap"
  hasBacground: true
  closable: false
  hasNameField: true

  events:
    "click .close" : "closeClicked"
  
  initialize: () ->
    @onLoginDone = @options.onLoginDone if typeof( @options.onLoginDone ) == "function"
    @hasNameField = @options.hasNameField if @options.hasNameField?
    
    @eventBus.bind "loginDone", @onLoginClosed
    @bootstrap()
  
  bootstrap: () ->
    @emailForm = new ADF.Login.Models.EmailForm({})
    
    @loginView = new ADF.Login.Views.Partial.Login
      popupView: @
      emailForm: @emailForm
      hasNameField: @hasNameField
      
    @resetPasswordView = new ADF.Login.Views.Partial.Reset
      popupView: @
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
    @eventBus.trigger "ADF.Login.Views.Main.DoneFacebookLogin"
    
  onLoginCancel: () =>
    @eventBus.trigger "ADF.Login.Views.Main.CancelLoginWindow"
    
