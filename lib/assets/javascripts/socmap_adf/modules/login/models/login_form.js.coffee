class ADF.Login.Models.LoginForm extends ADF.MVC.Models.Base
  
  # Assign model defaults
  defaults:
    email: null
    password: null

  url: -> 
    "/authorizme/sessions.json"
      
  constructor: ( options ) ->
    super( options )
    @markChecks = true
    @validates( "present", ["email", "password"], {message : "" })