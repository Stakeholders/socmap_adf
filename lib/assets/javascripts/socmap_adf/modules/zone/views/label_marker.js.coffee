class ADF.Zone.Views.LabelMarker

  icon: null
  iconUrl:  null
  iconSize: new google.maps.Size(1,20)
  iconOrigin: new google.maps.Point(0,0)
  iconAnchor: new google.maps.Point(0,0)

  shadow: null

  shape: null
  
  constructor: () ->
    @initMarkerImages()

  initMarkerImages: () ->
    @icon = new google.maps.MarkerImage(@iconUrl, @iconSize, @iconOrigin, @iconAnchor)

  getIcon: () ->
    @icon

  getShadow: () ->
    @shadow

  getShape: () ->
    @shape