class ADF.Map.Models.Location extends ADF.MVC.Models.Base

  url: -> 
    if @id then "/api/objects/#{@id}" else "/api/objects"

  defaults:
    id: null
    socmap_points: []
    socmap_object_type: null
    
  type : null

  initialize: (options) ->
    super(options)
    @type = options.type

  getGMPath: ->
    @_getGMPathFromSocmapPoints()

  setGMPath: (GMPath) ->
    @set("socmap_points", []) 
    @get("socmap_points").push {lat: latLng.lat(), lng: latLng: latLng.lng()} for latLng in GMPath
    
  getGMLatLng: ->
    @_getGMPathFromSocmapPoints()[0]

  setGMLatLng: (point) ->
    @set("socmap_points", [{lat: point.lat(), lng: point.lng()}])

  _getGMPathFromSocmapPoints: ->
    _path = []
    if @get("socmap_points")
      _path.push new google.maps.LatLng( socmap_point.lat, socmap_point.lng ) for socmap_point in @get("socmap_points")
    _path  