class ADF.Login.Models.EmailForm extends ADF.MVC.Models.Base
  
  defaults:
    email: null
    registred: null
  
  url: -> 
    "/api/users/find_registred_email.json?email=#{@get("email")}"
    
  constructor: (options) ->
    super(options)
    @markChecks = true
    @validates("email", ["email"], {message : ""})
    
    
  checkEmailRegistred: ( callback ) ->
    @fetch({ url: @url(), success: callback })

  registred: () ->
    if @get("registred") == true then true else false
    
  hasProvider: () ->
    if @get("provider") then true else false