ADF.Map.Views.Cluster ||= {}

class ADF.Map.Views.Cluster.ChartIcon extends ADF.Map.Views.Cluster.ClusterIcon

  initialize: () ->
    @fillColors = @markerClusterer_.getFillColors()

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
    @chartView = new ADF.Map.Views.Cluster.Chart({ fillColors: @fillColors, data: @sumData(), sum: @sums_ })

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
      marker.setMap @map_ if marker
    @visible_ = true
              
  sumData : ->
    dataHash = { 1 : 0, 2 : 0, 3 : 0 }
    markers = @cluster_.getMarkers()
    for marker in markers
      if marker.getData
        dataHash[ marker.getData() ] = if dataHash[ marker.getData() ]? then dataHash[ marker.getData() ] + 1 else 1
    @result = []
    $.each dataHash, (data, i) =>
      @result.push i
    @result

  isNeedToCluster: () ->
    markers = @cluster_.getMarkers()
    if markers.length > 1 then true else false

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

  addClickHandler: (handler) ->
    @clickHandler = handler