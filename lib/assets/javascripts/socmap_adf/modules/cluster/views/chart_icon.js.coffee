class ADF.Cluster.Views.ChartIcon extends google.maps.OverlayView

  constructor : (cluster, styles, opt_padding) ->
    @styles_ = styles
    @padding_ = opt_padding or 0
    @cluster_ = cluster
    @center_ = null
    @map_ = cluster.getMap()
    @chartView = null
    @sums_ = null
    @visible_ = false
    @setMap @map_

  triggerClusterClick : ->
    @clickHandler(@cluster_) if @clickHandler
    markerClusterer = @cluster_.getMarkerClusterer()
    google.maps.event.trigger markerClusterer, "clusterclick", @cluster_
    if markerClusterer.isZoomOnClick() and markerClusterer.getMaxZoomOnClick() > @map_.getZoom()
      @map_.fitBounds @cluster_.getBounds()
      if @map_.getZoom() > markerClusterer.getMaxZoomOnClick()
        @map_.setZoom(markerClusterer.getMaxZoomOnClick())
    
  onAdd : ->
    return unless @isNeedToCluster()
    @chartView = new ADF.Cluster.Views.Chart({ data: @sumData(), sum: @sums_ })

    if @visible_
      pos = @getPosFromLatLng_(@center_)
      @chartView.setPosition( pos )
      
    panes = @getPanes()
    panes.overlayMouseTarget.appendChild @chartView.render().el

    google.maps.event.addDomListener @chartView.el, "click", =>
      @triggerClusterClick()
      
  draw : ->
    if @visible_
      pos = @getPosFromLatLng_(@center_)
      @chartView.setPosition(pos, true) if @chartView

  hide : ->
    if @chartView?
      @chartView.hide()
      @visible_ = false

  show : ->
    if @chartView?
      pos = @getPosFromLatLng_(@center_)
      @chartView.setPosition(pos, true)
      @chartView.show()
    else if @cluster_.getMarkers() && @cluster_.getMarkers().length == 1
      marker = @cluster_.getMarkers()[0]
      marker.setMap @map_
      marker.getMarker().setMap @map_ if marker.getMarker()
    @visible_ = true

  showOrShowMarker : ->
              
  sumData : ->
    dataHash = { 1 : 0, 2 : 0, 3 : 0 }
    markers = @cluster_.getMarkers()
    for marker in markers
      dataHash[ marker.getData() ] = if dataHash[ marker.getData() ]? then dataHash[ marker.getData() ] + 1 else 1
    @result = []
    $.each dataHash, (data, i) =>
      @result.push i
    @result
    
  getPosFromLatLng_ : (latlng) ->
    pos = @getProjection().fromLatLngToDivPixel(latlng)
    pos.x -= parseInt(@width_ / 2, 10) if pos
    pos.y -= parseInt(@height_ / 2, 10) if pos
    pos

  isNeedToCluster: () ->
    markers = @cluster_.getMarkers()
    if markers.length > 1 then true else false
    
  remove : ->
    @setMap null

  onRemove : ->
    if @chartView and @chartView.$el.parent()
      @hide()
      @chartView.$el.remove()
      @chartView = null

  setSums : (sums) ->
    @sums_ = sums
    @text_ = sums.text
    @index_ = sums.index
    @useStyle()

  useStyle : ->
    index = Math.max(0, @sums_.index - 1)
    index = Math.min(@styles_.length - 1, index)
    style = @styles_[index]
    @height_ = style["height"]
    @width_ = style["width"] 

  setCenter : (center) ->
    @center_ = center

  addClickHandler: (handler) ->
    @clickHandler = handler