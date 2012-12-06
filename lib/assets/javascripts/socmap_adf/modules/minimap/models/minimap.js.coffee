class ADF.Minimap.Models.Minimap extends Backbone.Model

  overlays: []
  
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

  initGMap: (mapElement) ->
    @mapElement = mapElement
    @map = new google.maps.Map(document.getElementById(@mapElement), @attributes)
    @loadOSM() if @get("mapTypeId") == "OSM"
    return @map
    
  setMapTypeId: (mapTypeId) =>
    @loadOSM() if mapTypeId == "OSM"
    @map.setMapTypeId(mapTypeId)

  getGMap: () ->
    return @map
    
  getMapElement: () ->
    return $("##{@mapElement}")

  addOverlay: (overlay) ->
    @overlays.push(overlay)

  getOverlays: () ->
    @overlays

  hideAllOverlays: () ->
    for overlay in @overlays
      overlay.hide()

  setCenter: (latLng) ->
    @map.setCenter(latLng)

  fitBounds: (bounds) ->
    @map.fitBounds(bounds)

  clearMap: () ->    
    for overlay in @overlays
      overlay.setMap(null)
    @overlays = []
    
  loadOSM: () ->
    @map.mapTypes.set("OSM", new google.maps.ImageMapType(
        getTileUrl: (coord, zoom) =>
            return "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
        tileSize: new google.maps.Size(256, 256)
        name: "OpenStreetMap"
        maxZoom: 18
    ))