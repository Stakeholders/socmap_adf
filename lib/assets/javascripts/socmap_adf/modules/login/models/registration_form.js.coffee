class ADF.Login.Models.RegistrationForm extends ADF.MVC.Models.Base
  
  # Assign model defaults
  defaults:
    first_name: null
    email: null
    password: null
    password_confirmation: null

  url: -> 
    if @id then "/api/users/#{@id}.json" else "/api/users.json"
      
  constructor: ( options ) ->
    super( options )
    @markChecks = true
    
  setValidation: (options) ->
    @validates( "present", ["email", "password", "password_confirmation"], { message: "" } )
    @validates( "present", ["first_name"]) if options.hasNameField
    @validates( "email", ["email"], { message: "" })
    @validates( "confirm", ["password_confirmation"], {message: I18n.t("adf.error.not_equal"), confirm_field: "password"})