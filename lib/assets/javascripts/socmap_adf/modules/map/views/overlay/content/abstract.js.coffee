ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Abstract extends google.maps.OverlayView
  
  zindex: 1

  constructor: (options) ->
    @options = options
    @setMap(@options.marker.getMap())
    @bindMarkerEvents()
    @bindMapEvents()
    @options.marker.on "removedFromMap", @_onMarkerRemoved
    @draw()
    
  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @options.marker, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @options.marker, 'dragend', (e) =>
      @draw()
      @show()

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerDragstartEvent)
    google.maps.event.removeListener(@markerDragendEvent)         

  bindMapEvents: () ->
    @dragstartEvent = google.maps.event.addListener @getMap(), 'dragstart', () =>
      @draw()

    @dragendEvent = google.maps.event.addListener @getMap(), 'dragend', () =>
      @draw()

    @centerChangedEvent = google.maps.event.addListener @getMap(), 'center_changed', () =>
      @draw()

  unbindMapEvents: () =>
    google.maps.event.removeListener(@dragstartEvent)
    google.maps.event.removeListener(@dragendEvent)
    google.maps.event.removeListener(@centerChangedEvent)   

  # = Show or Hide overlay
  show: ( animation = false ) ->
    if @div
      if animation
        $(@div).fadeIn("fast")
      else
        $(@div).show()

  hide: ( animation = false ) ->
    $(@div).hide() if @div

  # = From OverlayView 
  onAdd: ->
    if @options.view
      @div = @options.view.render().el
      $(@options.marker.mapModel.getMapElement()).append(@div)

  draw: () =>
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @options.marker.getPosition() && @div)
      $(@div).css({position: "absolute", left: 0, top: 0})
      @divPixel = overlayProjection.fromLatLngToContainerPixel(@options.marker.getPosition())
      markerSize = @options.marker.options.icon.size
      markerWidth = markerSize.width
      markerHeight = markerSize.height
      overlayWidth = $(@div).width()
      overlayHeight = $(@div).height()
      leftOffset = @options.leftOffset || 0
      topOffset = @options.topOffset || 0
      
      if @options.position == "left"
        @left = @divPixel.x - overlayWidth - (markerWidth/2) + leftOffset
        @top = @divPixel.y - markerHeight + topOffset
      else if @options.position == "right"
        @left = @divPixel.x + (markerWidth/2) + leftOffset
        @top = @divPixel.y - markerHeight + topOffset
      else if @options.position == "top"
        @left = @divPixel.x - (overlayWidth/2) + leftOffset
        @top = @divPixel.y - markerHeight - overlayHeight + topOffset
      else
        @left = @divPixel.x - (overlayWidth/2) + leftOffset
        @top = @divPixel.y + topOffset
        
    if (@div)
      $(@div).css({left: @left, top: @top})

  redraw: (event) ->
    @draw()
  
  onRemove: () =>
    @unbindMapEvents()
    @unbindMarkerEvents()
    $(@div).remove() if @div
    @div = null if @div
    
  _onMarkerRemoved: () =>
    @setMap(null)

  setInFront: () ->
    @zindex = @zindex + 1
    @draw()

  setBack: () ->
    @zindex = @zindex - 1
    @draw()