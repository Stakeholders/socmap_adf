class ADF.Form.Models.Error

  type: null
  message: "Error"
  value: null
  attribute: null
  
  constructor: (type, message, attribute, value) ->
    @type = type
    @message = message
    @attribute = attribute
    @value = value