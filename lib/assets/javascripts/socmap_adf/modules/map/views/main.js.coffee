class ADF.Map.Views.Main extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/map/templates/main']
  left: 370
  top: 0
  heightOffset: 39
  map_id: "adf_map_canvas"
  mapOptions: {}
  clusterOptions: {}
  
  constructor: (options) ->
    super(options) 
    @model = new ADF.Map.Models.Map(@mapOptions, @clusterOptions)
    @map_id = options.map_id if options.map_id
    
  render: () ->
    @containerArea = @make("div", {"id" : @map_id} )
    @setElement( @containerArea )
    @
  
  renderMap: ->
    @bindResizeEvents()
    @model.initGMap(@map_id)
    @tooltip = new ADF.Map.Views.Tooltip({map: @getMap(), containerArea: @containerArea })
    @resize()
    @initTooltip()
    @onRenderCompleted()
    
  initTooltip: () ->
    $("body").append( @tooltip.render().el )
        
  bindResizeEvents: ->
    $(window).resize =>
      @resize()
          
    $(document).ready =>
      @resize()
  
  resize: ->
    height = $(window).height() - @heightOffset
    width = $(window).width() - @left
    $(@containerArea).css({"position" : "absolute", "top" : @top + "px", "left" : @left + "px", "height" : height + "px", "width" : width + "px"})
    google.maps.event.trigger( @model.getGMap(), "resize") if @model.getGMap()

  getMap: () ->
    @model

  setCenter: (latLng) ->
    @model.setCenter(latLng)

  setZoom: (zoom) ->
    @getGMap().setZoom(zoom)
    
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
    
  getGMap: () ->
    @model.getGMap()

  getProjection: () ->
    @getGMap().getProjection()

  fitBounds: (bounds_array, centerWithOffset = false) ->
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