class ADF.Map.Models.Map extends Backbone.Model

  overlays: []
  clustered_overlays: []

  maxZoomLevelForClustering: 21
  maxZoomOnClick: 18
  mapElement: null

  defaults:
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

  clusterDefaults:
    "maxZoom": 21
    "maxZoomOnClick": 21
    "clusterShowType": "chart"

  constructor: (options, clusterOptions) ->
    super(options)
    @clusterOptions = $.extend(@clusterDefaults, clusterOptions)
    
  initGMap: (mapElement) ->
    @mapElement = mapElement
    @map = new google.maps.Map(document.getElementById(@mapElement), @attributes)
    @markerClusterer = new ADF.Cluster.Views.MarkerClusterer(@map, null, @clusterOptions)
    @loadOSM() if @get("mapTypeId") == "OSM"
    return @map
    
  setMapTypeId: (mapTypeId) =>
    @loadOSM() if mapTypeId == "OSM"
    @map.setMapTypeId(mapTypeId)

  getGMap: () ->
    return @map
    
  getMapElement: () ->
    return $("##{@mapElement}")

  addOverlay: (overlay, clustering = false) ->
    @overlays.push(overlay)
    @clusterOverlay(overlay) if clustering || overlay.isClustering()

  setCenter: (latLng) ->
    @map.setCenter(latLng)
    
  hideZoomControl: () ->
    @map.setOptions({zoomControl: false})
    
  showZoomControl: () ->
    @map.setOptions({zoomControl: true})
    
  fitBounds: (bounds) ->
    @map.fitBounds(bounds)

  clearMap: () ->
    for overlay in @overlays
      overlay.marker.setMap(null) if overlay.marker?
      overlay.setMap(null)
      @markerClusterer.removeMarker(overlay) if @markerClusterer && overlay.isClustering()
    @overlays = []
    @markerClusterer.clearMarkers()

  getOverlays: () ->
    @overlays

  hideAllOverlays: () ->
    for overlay in @overlays
      overlay.hide()

  clusterOverlay: (overlay) ->
    @markerClusterer.addMarker(overlay) if @markerClusterer
    
  loadOSM: () ->
    @map.mapTypes.set("OSM", new google.maps.ImageMapType(
        getTileUrl: (coord, zoom) =>
            return "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
        tileSize: new google.maps.Size(256, 256)
        name: "OpenStreetMap"
        maxZoom: 18
    ))
    