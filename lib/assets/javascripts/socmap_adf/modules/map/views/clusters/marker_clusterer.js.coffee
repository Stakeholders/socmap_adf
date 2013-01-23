ADF.Map.Views.Cluster ||= {}

class ADF.Map.Views.Cluster.MarkerClusterer extends google.maps.OverlayView

  MARKER_CLUSTER_IMAGE_PATH_ : "http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/" + "images/m"
  MARKER_CLUSTER_IMAGE_EXTENSION_ : "png"
  FILL_COLORS : ["#ff6700", "#0094ff", "#529900"]
  DEFAULT_CLUSTER_ICON_CLASS: ADF.Map.Views.Cluster.DefaultIcon
  
  constructor: (map, opt_markers, opt_options) ->
    @map_ = map
    @setMap(@map_)

    @markers_ = []

    @clusters_ = []
    @sizes = [53, 56, 66, 78, 90]
    # @sizes = [1, 1, 1, 1, 1]

    @styles_ = []

    @ready_ = false
    options = opt_options or {}

    @clusterShowType_ = options["clusterShowType"] or "default"

    @gridSize_ = options["gridSize"] or 100

    @minClusterSize_ = options["minimumClusterSize"] or 2

    @maxZoom_ = options["maxZoom"] or null
    @styles_ = options["styles"] or []
    
    @fillColors = opt_options.fillColors or @FILL_COLORS
    
    @clusterIconClass_ = opt_options.clusterIconClass or @DEFAULT_CLUSTER_ICON_CLASS

    @imagePath_ = options["imagePath"] or @MARKER_CLUSTER_IMAGE_PATH_

    @imageExtension_ = options["imageExtension"] or @MARKER_CLUSTER_IMAGE_EXTENSION_

    @zoomOnClick_ = true
    @zoomOnClick_ = options["zoomOnClick"]  unless options["zoomOnClick"] is `undefined`

    @showAllClusters_ = false
    @showAllClusters_ = options["showAllClusters"] unless options["showAllClusters"] is `undefined`

    @maxZoomOnClick_ = options["maxZoomOnClick"] or 20

    @averageCenter_ = false
    @averageCenter_ = options["averageCenter"]  unless options["averageCenter"] is `undefined`
    @setupStyles_()

    @prevZoom_ = @map_.getZoom()
    
    # Add the map event listeners
    that = this
    google.maps.event.addListener @map_, "zoom_changed", ->
      zoom = that.map_.getZoom()
      unless that.prevZoom_ is zoom
        that.prevZoom_ = zoom
        that.resetViewport()

    google.maps.event.addListener @map_, "idle", ->
      that.redraw()
    
    # Finally, add the markers
    @addMarkers opt_markers, false if opt_markers and opt_markers.length

  onAdd: () ->
    @setReady_ true

  draw: () ->

  onRemove: () ->

  extend: (obj1, obj2) ->
    ((object) ->
      for property of object::
        @::[property] = object::[property]
      this
    ).apply obj1, [obj2]

  setupStyles_: ->
    return  if @styles_.length
    i = 0
    size = undefined

    while size = @sizes[i]
      @styles_.push
        url: @imagePath_ + (i + 1) + "." + @imageExtension_
        height: size
        width: size

      i++

  fitMapToMarkers: ->
    markers = @getMarkers()
    bounds = new google.maps.LatLngBounds()
    i = 0
    marker = undefined

    while marker = markers[i]
      bounds.extend marker.getPosition()
      i++
    @map_.fitBounds bounds

  getClusterShowType: () ->
    @clusterShowType_
    
  getFillColors: () ->
    @fillColors
    
  getClusterIconClass: () ->
    @clusterIconClass_

  setFillColors: (fillColors) ->
    @fillColors = fillColors

  setStyles: (styles) ->
    @styles_ = styles

  getStyles: ->
    @styles_

  isZoomOnClick: ->
    @zoomOnClick_

  getMaxZoomOnClick: ->
    @maxZoomOnClick_

  isAverageCenter: ->
    @averageCenter_

  getMarkers: ->
    @markers_

  getTotalMarkers: ->
    @markers_.length

  setMaxZoom: (maxZoom) ->
    @maxZoom_ = maxZoom

  getMaxZoom: ->
    @maxZoom_

  calculator_: (markers, numStyles) ->
    index = 0
    count = markers.length
    dv = count
    while dv isnt 0
      dv = parseInt(dv / 10, 10)
      index++
    index = Math.min(index, numStyles)
    text: count
    index: index

  setCalculator: (calculator) ->
    @calculator_ = calculator

  getCalculator: ->
    @calculator_

  addMarkers: (markers, opt_nodraw) ->
    i = 0
    marker = undefined

    while marker = markers[i]
      @pushMarkerTo_ marker
      i++
    @redraw()  unless opt_nodraw

  pushMarkerTo_: (marker) ->
    marker.isAdded = false
    if marker["draggable"]
      
      # If the marker is draggable add a listener so we update the clusters on
      # the drag end.
      that = this
      google.maps.event.addListener marker, "dragend", ->
        marker.isAdded = false
        that.repaint()

    @markers_.push marker

  addMarker: (marker, opt_nodraw) ->
    @pushMarkerTo_ marker
    @redraw() unless opt_nodraw

  removeMarker_: (marker) ->
    index = -1
    if @markers_.indexOf
      index = @markers_.indexOf(marker)
    else
      i = 0
      m = undefined

      while m = @markers_[i]
        if m is marker
          index = i
          break
        i++
    
    # Marker is not in our list of markers.
    return false  if index is -1
    marker.setMap null if marker
    marker.setMap null
    @markers_.splice index, 1
    true

  removeMarker: (marker, opt_nodraw) ->
    removed = @removeMarker_(marker)
    if not opt_nodraw and removed
      @resetViewport()
      @redraw()
      true
    else
      false

  removeMarkers: (markers, opt_nodraw) ->
    removed = false
    i = 0
    marker = undefined

    while marker = markers[i]
      r = @removeMarker_(marker)
      removed = removed or r
      i++
    if not opt_nodraw and removed
      @resetViewport()
      @redraw()
      true

  setReady_: (ready) ->
    unless @ready_
      @ready_ = ready
      @createClusters_()

  getTotalClusters: ->
    @clusters_.length

  getMap: ->
    @map_

  getGridSize: ->
    @gridSize_

  setGridSize: (size) ->
    @gridSize_ = size

  getMinClusterSize: () ->
    @minClusterSize_

  setMinClusterSize: (size) ->
    @minClusterSize_ = size

  getExtendedBounds: (bounds) ->
    projection = @getProjection()
    
    # Turn the bounds into latlng.
    tr = new google.maps.LatLng(bounds.getNorthEast().lat(), bounds.getNorthEast().lng())
    bl = new google.maps.LatLng(bounds.getSouthWest().lat(), bounds.getSouthWest().lng())
    
    # Convert the points to pixels and the extend out by the grid size.
    trPix = projection.fromLatLngToDivPixel(tr)
    trPix.x += @gridSize_
    trPix.y -= @gridSize_
    blPix = projection.fromLatLngToDivPixel(bl)
    blPix.x -= @gridSize_
    blPix.y += @gridSize_
    
    # Convert the pixel points back to LatLng
    ne = projection.fromDivPixelToLatLng(trPix)
    sw = projection.fromDivPixelToLatLng(blPix)
    
    # Extend the bounds to contain the new bounds.
    bounds.extend ne
    bounds.extend sw
    bounds

  isMarkerInBounds_: (marker, bounds) ->
    bounds.contains marker.getPosition()

  clearMarkers: () ->
    @resetViewport true
    
    # Set the markers a empty array.
    @markers_ = []

  resetViewport: (opt_hide) ->
    # Remove all the clusters
    i = 0
    cluster = undefined

    while cluster = @clusters_[i]
      cluster.remove()
      i++
    
    # Reset the markers to not be added and to be invisible.
    i = 0
    marker = undefined

    while marker = @markers_[i]
      marker.isAdded = false
      marker.setMap null if opt_hide and marker
      marker.setMap null if opt_hide
      i++
    @clusters_ = []

  repaint: ->
    oldClusters = @clusters_.slice()
    @clusters_.length = 0
    @resetViewport()
    @redraw()
    
    # Remove the old clusters.
    # Do it in a timeout so the other clusters have been drawn first.
    window.setTimeout (->
      i = 0
      cluster = undefined

      while cluster = oldClusters[i]
        cluster.remove()
        i++
    ), 0

  redraw: ->
    @createClusters_()

  distanceBetweenPoints_: (p1, p2) ->
    return 0  if not p1 or not p2
    R = 6371 # Radius of the Earth in km
    dLat = (p2.lat() - p1.lat()) * Math.PI / 180
    dLon = (p2.lng() - p1.lng()) * Math.PI / 180
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(p1.lat() * Math.PI / 180) * Math.cos(p2.lat() * Math.PI / 180) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c
    d

  addToClosestCluster_: (marker) ->
    distance = 40000 # Some large number
    clusterToAddTo = null
    pos = marker.getPosition()
    i = 0
    cluster = undefined

    while cluster = @clusters_[i]
      center = cluster.getCenter()
      if center
        d = @distanceBetweenPoints_(center, marker.getPosition())
        if d < distance
          distance = d
          clusterToAddTo = cluster
      i++
    if clusterToAddTo and clusterToAddTo.isMarkerInClusterBounds(marker)
      clusterToAddTo.addMarker marker
    else
      cluster = new ADF.Map.Views.Cluster.Cluster(@)
      cluster.addMarker marker
      @clusters_.push cluster

  createClusters_: () ->
    return unless @ready_
    
    # Get our current map view bounds.
    # Create a new bounds object so we don't affect the map.
    mapBounds = new google.maps.LatLngBounds(@map_.getBounds().getSouthWest(), @map_.getBounds().getNorthEast())
    bounds = @getExtendedBounds(mapBounds)
    i = 0
    marker = undefined

    while marker = @markers_[i]
      @addToClosestCluster_ marker if not marker.isAdded and (@showAllClusters_ || @isMarkerInBounds_(marker, bounds))
      i++
    google.maps.event.trigger @map_, "clustersCreatedForViewPoint", @clusters_