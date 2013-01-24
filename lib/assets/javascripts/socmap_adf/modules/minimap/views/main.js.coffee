class ADF.Minimap.Views.Main extends ADF.MVC.Views.Base
  
  mapOptions: {}
  map_id: "adf_minimap_canvas"
  
  constructor: (options) ->
    super(options) 
    @model = new ADF.Minimap.Models.Minimap(@mapOptions)
    @map_id = options.map_id if options.map_id
    
  render: () ->
    @containerArea = $("<div>", {"id" : @map_id} )
    @setElement( @containerArea )
    @
    
    return this 
  
  renderMap: ->
    @bindResizeEvents()
    @model.initGMap(@map_id)
    @tooltip = new ADF.Minimap.Views.Tooltip({map: @getMap(), containerArea: @containerArea })
    @resize()
    @initTooltip()
    @onRenderCompleted()

  initTooltip: () ->
    $(@containerArea).append( @tooltip.render().el )
              
  bindResizeEvents: ->
    $(window).resize =>
      @resize()
          
    $(document).ready =>
      @resize()
  
  resize: ->
    $(@containerArea).css({"position" : "relative", "height" : "100%", "width" : "100%"})
    google.maps.event.trigger( @model.getGMap(), "resize") if @model.getGMap()

  getMap: () ->
    @model
    
  getGMap: () ->
    @model.getGMap()

  setCenter: (latLng) ->
    @model.setCenter(latLng)
    
  setMapTypeId: (mapTypeId) ->
    @model.setMapTypeId(mapTypeId)

  setCenterWithOffset: (position, offsetx, offsety) ->
    @model.setCenter(position)
    zoomLevel = @model.getGMap().getZoom()
    max = Math.pow(2,zoomLevel) * 256;
    lng = -(offsetx / max) * 100 + position.lng()
    lat = -(offsety / max) * 100 + position.lat()
    pos = new google.maps.LatLng(lat, lng)
    @model.setCenter(pos)
    
  fitBounds: (bounds_array, centerWithOffset) ->
    if bounds_array
      bounds = new google.maps.LatLngBounds()
      _.each bounds_array, (marker) =>
        bounds.extend(new google.maps.LatLng(marker.lat, marker.lng))
      @model.fitBounds(bounds)
      @model.getGMap().setZoom(@model.getGMap().getZoom() - 1)
      @setCenterWithOffset(@model.getGMap().getCenter(), 0, -300) if centerWithOffset
    
  addContextMenu: () ->
    @contextMenu = new ADF.GMap.Views.ContextMenu({gElement : @getGMap(), mapModel: @model})
    @contextMenu.render()
        
  # Callback methods
  onRenderCompleted: () ->