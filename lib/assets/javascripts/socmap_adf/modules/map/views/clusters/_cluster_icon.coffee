ADF.Map.Views.Cluster ||= {}

class ADF.Map.Views.Cluster.ClusterIcon extends google.maps.OverlayView

  constructor : (options) ->
    @cluster_ = options.cluster
    @markerClusterer_ = options.markerClusterer
    @styles_ = @markerClusterer_.getStyles()
    @padding_ = @markerClusterer_.getGridSize() or 0
    @center_ = null
    @map_ = @cluster_.getMap()
    @div_ = null
    @visible_ = false
    @initialize() if @initialize
    @setMap @map_

  ###
  Triggers the clusterclick event and zoom's if the option is set.
  ###
  triggerClusterClick : ->    
    # Trigger the clusterclick event.
    google.maps.event.trigger @markerClusterer_, "clusterclick", @cluster_
    
    # Zoom into the cluster.
    @map_.fitBounds @cluster_.getBounds()  if @markerClusterer_.isZoomOnClick()


  ###
  Adding the cluster icon to the dom.
  @ignore
  ###
  onAdd : ->
    @div_ = document.createElement("DIV")
    if @visible_
      pos = @getPosFromLatLng_(@center_)
    panes = @getPanes()
    panes.overlayMouseTarget.appendChild @div_
    that = this
    google.maps.event.addDomListener @div_, "click", ->
      that.triggerClusterClick()

  ###
  Returns the position to place the div dending on the latlng.

  @param {google.maps.LatLng} latlng The position in latlng.
  @return {google.maps.Point} The position in pixels.
  @private
  ###
  getPosFromLatLng_ : (latlng) ->
    pos = @getProjection().fromLatLngToDivPixel(latlng)
    pos.x -= parseInt(@width_ / 2, 10)
    pos.y -= parseInt(@height_ / 2, 10)
    pos


  ###
  Draw the icon.
  @ignore
  ###
  draw : ->
    if @visible_
      pos = @getPosFromLatLng_(@center_)
      @div_.style.top = pos.y + "px"
      @div_.style.left = pos.x + "px"

  ###
  Hide the icon.
  ###
  hide : ->
    @div_.style.display = "none"  if @div_
    @visible_ = false

  ###
  Position and show the icon.
  ###
  show : ->
    if @div_
      pos = @getPosFromLatLng_(@center_)
      @div_.style.cssText = @createCss(pos)
      @div_.style.display = ""
    @visible_ = true


  ###
  Remove the icon from the map
  ###
  remove : ->
    @setMap null

  ###
  Implementation of the onRemove interface.
  @ignore
  ###
  onRemove : ->
    if @div_ and @div_.parentNode
      @hide()
      @div_.parentNode.removeChild @div_
      @div_ = null
      
  ###
  Sets the center of the icon.

  @param {google.maps.LatLng} center The latlng to set as the center.
  ###
  setCenter : (center) ->
    @center_ = center

  ###
  Set the sums of the icon.

  @param {Object} sums The sums containing:
  'text': (string) The text to display in the icon.
  'index': (number) The style index of the icon.
  ###
  setSums : (sums) ->