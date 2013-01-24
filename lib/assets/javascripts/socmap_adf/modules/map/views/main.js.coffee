class ADF.Map.Views.Main extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/map/templates/main']
  left: 370
  top: 0
  heightOffset: 39
  mapElementId: "adf_map_canvas"
  mapDefaultOptions:
    center: new google.maps.LatLng(57,25)
    zoom: 7
    mapTypeId: google.maps.MapTypeId.HYBRID
    mapTypeControl: false
    zoomControl: true
    zoomControlOptions:
      style: google.maps.ZoomControlStyle.SMALL
      position: google.maps.ControlPosition.RIGHT_TOP
    panControl: false
    streetViewControl: false
  clusterOptions: {}
  
  constructor: (options) ->
    super(options) 
    @mapOptions = $.extend(@mapDefaultOptions, @mapOptions)
    @mapElementId = options.mapElementId if options.mapElementId

  render: () ->
    @containerArea = $("<div>", {"id" : @mapElementId} )
    @setElement( @containerArea )
    @
  
  renderMap: ->
    @bindResizeEvents()
    @mapOptions.clusterOptions = @clusterOptions
    @mapOptions.mapElementId = @mapElementId    
    @map = new ADF.Map.Views.Map(document.getElementById(@mapElementId), @mapOptions)
    @map.setMapTypeId(@mapOptions.mapTypeId) if @mapOptions.mapTypeId == "OSM"
    
    @tooltip = new ADF.Map.Views.Tooltip.Text({map: @map, containerArea: @containerArea })
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
    google.maps.event.trigger( @map, "resize") if @map

  getMap: () ->
    @map

  setCenter: (latLng) ->
    @map.setCenter(latLng)

  setZoom: (zoom) ->
    @map.setZoom(zoom)
    
  setMapTypeId: (mapTypeId) ->
    @map.setMapTypeId(mapTypeId)

  setCenterWithOffset: (position, offsetx, offsety) ->
    @map.setCenter(position)
    zoomLevel = @map.getZoom()
    max = Math.pow(2,zoomLevel) * 256;
    lng = -(offsetx / max) * 100 + position.lng()
    lat = -(offsety / max) * 100 + position.lat()
    pos = new google.maps.LatLng(lat, lng)
    @map.setCenter(pos)
    
  getGMap: () ->
    @map

  getProjection: () ->
    @map.getProjection()

  fitBounds: (bounds_array, centerWithOffset = false) ->
    if bounds_array
      bounds = new google.maps.LatLngBounds()
      _.each bounds_array, (marker) =>
        bounds.extend(new google.maps.LatLng(marker.lat, marker.lng))
      @map.fitBounds(bounds)
      @map.setZoom(@map.getZoom() - 1)
      @setCenterWithOffset(@map.getCenter(), 0, -300) if centerWithOffset
    
  addContextMenu: () ->
    @contextMenu = new ADF.GMap.Views.ContextMenu({gElement : @map, mapModel: @map})
    @contextMenu.render()
    
  # Callback methods
  onRenderCompleted: () ->