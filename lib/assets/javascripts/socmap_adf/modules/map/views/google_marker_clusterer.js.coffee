class ADF.Map.Views.GoogleMarkerClusterer extends google.maps.OverlayView
  
  onAdd: () ->
    @setReady_ true

  draw: () ->

  onRemove: () ->

  constructor: (map, opt_markers, opt_options) ->
    @map_ = map