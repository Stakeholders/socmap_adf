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
    return @map

  getGMap: () ->
    return @map
    
  getMapElement: () ->
    return $("##{@mapElement}")

  addOverlay: (overlay) ->
    @overlays.push(overlay)

  setCenter: (latLng) ->
    @map.setCenter(latLng)

  fitBounds: (bounds) ->
    @map.fitBounds(bounds)

  clearMap: () ->
    for overlay in @overlays
      overlay.setMap(null)
    @overlays = []