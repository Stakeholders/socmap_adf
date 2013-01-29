class ADF.Login.Models.RegistrationForm extends ADF.MVC.Models.Base
  
  # Assign model defaults
  defaults:
    first_name: null
    last_name: null
    email: null
    password: null
    password_confirmation: null

  url: -> 
    if @id then "/api/users/#{@id}.json" else "/api/users.json"
      
  constructor: ( options ) ->
    super( options )
    @markChecks = true
    @validates( "present", ["first_name", "last_name", "email", "password", "password_confirmation"], { message: I18n.t("adf.error.required") } )
    @validates( "email", ["email"], { message: I18n.t("adf.error.email_not_valid") })
    @validates( "confirm", ["password_confirmation"], {message: I18n.t("adf.error.not_equal"), confirm_field: "password"})