class ADF.Map.Views.Map extends google.maps.Map
  
  overlays: []
  clustered_overlays: []

  maxZoomLevelForClustering: 21
  maxZoomOnClick: 18
  mapElementId: null

  clusterDefaults:
    "maxZoom": 21
    "maxZoomOnClick": 21
    "clusterShowType": "default"

  constructor: (element, options) ->
    super(element, options)
    @clusterOptions = $.extend(@clusterDefaults, options.clusterOptions)
    @mapElementId = options.mapElementId
    @markerClusterer = new ADF.Map.Views.Cluster.MarkerClusterer(@, null, @clusterOptions)
    @

  setMapTypeId: (mapTypeId) =>
    super(mapTypeId)
    @loadOSM() if @mapTypes && mapTypeId == "OSM"

  getGMap: () ->
    return @
    
  getMapElement: () ->
    return $("##{@mapElementId}")

  addOverlay: (overlay, clustering = false) ->
    @overlays.push(overlay)
    @clusterOverlay(overlay) if clustering || (overlay.isClustering && overlay.isClustering())
    
  hideZoomControl: () ->
    @setOptions({zoomControl: false})
    
  showZoomControl: () ->
    @setOptions({zoomControl: true})

  clearMap: () ->
    for overlay in @overlays
      overlay.setMap(null)
      overlay.marker.setMap(null) if overlay.marker?
      @markerClusterer.removeMarker(overlay) if @markerClusterer && overlay.isClustering && overlay.isClustering()
    @overlays = []
    @markerClusterer.clearMarkers() if @markerClusterer

  getOverlays: () ->
    @overlays

  clusterOverlay: (overlay) ->
    @markerClusterer.addMarker(overlay) if @markerClusterer

  setClusterFillColors: (fillColors) =>
    @markerClusterer.setFillColors(fillColors) if @markerClusterer
      
  loadOSM: () ->
    @mapTypes.set("OSM", new google.maps.ImageMapType(
        getTileUrl: (coord, zoom) =>
            return "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
        tileSize: new google.maps.Size(256, 256)
        name: "OpenStreetMap"
        maxZoom: 18
    ))