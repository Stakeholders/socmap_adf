class ADF.Zone.Models.Polygon extends Backbone.Model   
  GPolygon: null
  readOnly: true
  done: false
  
  initialize: (options) ->
    super()
    @polygon_options_defaults =
      strokeColor: "#f600ff"
      strokeOpacity: 0.8
      strokeWeight: 3
      fillColor: "#fb98ff"
      fillOpacity: 0.30
      editable: true
    
    @polygon_options_readonly =
      strokeColor: "#FFFFFF"
      strokeOpacity: 1
      strokeWeight: 3
      fillColor: "#FFFFFF"
      fillOpacity: 0
      editable: false
      clickable: false
        
    @polygon_options_defaults.strokeColor = options.zoneColor if options.zoneColor
    @polygon_options_defaults.fillColor = options.zoneColor if options.zoneColor
    @polygon_options_readonly.strokeColor = options.lineColor if options.lineColor
    @polygon_options_readonly.fillColor = options.zoneColor if options.zoneColor
    @polygon_options_readonly.fillOpacity = options.opacity if options.opacity
    
    @readOnly = options.read_only
    @GPolygon = new google.maps.Polygon
      
  setPolygon: ( polygon ) =>
    @GPolygon = polygon

  getPolygon: ->
    @GPolygon
    
  removeFromMap: () ->
    @GPolygon.setMap( null ) 
  
  setPolygonMap: (map)->
    @GPolygon.setMap( map ) 
                  
  setEditable: ( readOnly ) ->
    if readOnly? then @readOnly = readOnly
    @GPolygon.setOptions( @polygon_options_defaults ) if not @readOnly
    
  setUnEditable: ( readOnly ) ->
    if readOnly? then @readOnly = readOnly
    @polygon_options_readonly.clickable = if @readOnly then false else true 
    @GPolygon.setOptions( @polygon_options_readonly )
  
  createPolygonFromPoints: ( options ) ->
    @GPolygon.setOptions options
    @setEditable()
  
  setColors: (fillColor, strokeColor) ->
    @GPolygon.setOptions({fillColor: fillColor, strokeColor: strokeColor})
    @polygon_options_defaults["strokeColor"] = strokeColor 
    @polygon_options_defaults["fillColor"] = fillColor
    @polygon_options_readonly["strokeColor"] = strokeColor
    @polygon_options_readonly["fillColor"] = fillColor
    
  getCoordinates: ->
    points = [] 
    numPaths = @GPolygon.getPath().getLength()
    p = 0
    while p < numPaths
      points.push @getPointByOrder( p )
      p++
    points
  
  getPointByOrder: ( order ) ->
    @GPolygon.getPath().getAt(order)
    
  containsLatLng: ( point ) ->
    google.maps.geometry.poly.containsLocation point, @GPolygon
