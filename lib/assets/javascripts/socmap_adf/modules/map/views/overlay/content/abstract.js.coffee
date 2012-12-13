ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Abstract extends google.maps.OverlayView

  constructor: (options) ->
    @options = options
    @zindex = 1
    @_events = []
    @setMap(@options.overlay.getMap())
    @bindMarkerEvents()
    @bindExtraEvents()
    @bindMapEvents()
    @options.overlay.on "removedFromMap", @_onMarkerRemoved
    @draw()
    
  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @options.overlay, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @options.overlay, 'dragend', (e) =>
      @draw()
      @show()

  bindExtraEvents: () ->
    @options.overlay.on "pathChanged", () =>
      @draw()

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
      $(@options.overlay.mapModel.getMapElement()).append(@div)

  draw: () =>
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @options.overlay.getPosition() && @div)
      $(@div).css({position: "absolute", left: 0, top: 0})
      @divPixel = overlayProjection.fromLatLngToContainerPixel(@options.overlay.getPosition())
      markerSize = if @options.overlay.options.icon then @options.overlay.options.icon.size else {width: 0, height: 0}
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
    google.maps.event.removeListener(event) for event in @_events
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
    
  addListener: (event, callback) ->
    @_events.push(google.maps.event.addListener @, event, callback)

  addDomListener: (event, callback) ->
    @_events.push(google.maps.event.addDomListener @div, event, callback)