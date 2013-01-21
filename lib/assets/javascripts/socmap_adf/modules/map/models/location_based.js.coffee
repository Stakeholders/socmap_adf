class ADF.Map.Models.LocationBased extends ADF.MVC.Models.Base
  
  locationReleatedModelName: null

  constructor: (attributes) ->
    attributes = @_initSocmapObjectInAttributes(attributes)
    super(attributes)
    @attributes = attributes
    
  parse: (response) =>
    if response
      attributes = super(response)
      attributes = @_initSocmapObjectInAttributes(attributes)
      attributes
    
  _initSocmapObjectInAttributes: (attributes) ->
    if attributes && attributes.socmap_object
      options = attributes.socmap_object
    else
      options = {}
    options.type = @socmapObjectType
    options.releated_id = @.id if @.id
    options.releated_model_name = @locationReleatedModelName if @locationReleatedModelName
    obj = new ADF.Map.Models.Location(options)
    attributes = {} unless attributes
    attributes.socmap_object = obj
    attributes