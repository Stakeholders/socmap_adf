class ADF.GMap.Views.CustomMarker

  icon: null
  iconUrl: 'assets/markers/green_marker.png'
  iconSize: new google.maps.Size(29,50)
  iconOrigin: new google.maps.Point(0,0)
  iconAnchor: new google.maps.Point(15,50)

  shadow: null
  shadowUrl: 'assets/markers/green_marker_shadow.png'
  shadowSize: new google.maps.Size(57,50)
  shadowOrigin: new google.maps.Point(0,0)
  shadowAnchor: new google.maps.Point(15,50)

  shape: null
  shapeCoord: [17,0,20,1,22,2,23,3,24,4,25,5,26,6,26,7,27,8,27,9,28,10,28,11,28,12,28,13,28,14,28,15,28,16,28,17,28,18,27,19,27,20,27,21,26,22,25,23,25,24,24,25,23,26,23,27,22,28,21,29,21,30,21,31,22,32,23,33,23,34,24,35,24,36,25,37,25,38,25,39,25,40,25,41,25,42,24,43,24,44,23,45,23,46,22,47,21,48,19,49,10,49,8,48,7,47,7,46,6,45,5,44,4,43,4,42,4,41,4,40,4,39,4,38,4,37,4,36,4,35,5,34,6,33,6,32,8,31,8,30,7,29,6,28,6,27,5,26,4,25,4,24,3,23,2,22,2,21,1,20,1,19,0,18,0,17,0,16,0,15,0,14,0,13,0,12,0,11,1,10,1,9,1,8,2,7,2,6,3,5,4,4,5,3,6,2,8,1,11,0,17,0]

  constructor: () ->
    @initMarkerImages()

  initMarkerImages: () ->
    @icon = new google.maps.MarkerImage(@iconUrl, @iconSize, @iconOrigin, @iconAnchor)
    @shadow = new google.maps.MarkerImage(@shadowUrl, @shadowSize, @shadowOrigin, @shadowAnchor) if @shadowUrl
    @shape = {
      coord: @shapeCoord
      type: 'poly'
    }

  getIcon: () ->
    @icon

  getShadow: () ->
    @shadow

  getShape: () ->
    @shape