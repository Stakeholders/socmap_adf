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
    @options.overlay.on "isOnMap", @_onOverlayIsOnMap
    @draw()
    @_idleMap = null
    
  bindMarkerEvents: () ->
    @markerDragstartEvent = google.maps.event.addListener @options.overlay, 'dragstart', (e) =>
      @hide()

    @markerDragendEvent = google.maps.event.addListener @options.overlay, 'dragend', (e) =>
      @draw()
      @show()
      
  bindMapEvents: () ->
    @mapZoomChangedEvent = google.maps.event.addListener @options.overlay.getMap(), "zoom_changed", (e) =>
      @_idleMap = @getMap()
      @setMap(null) if @_idleMap
      
    @mapIdleEvent = google.maps.event.addListener @options.overlay.getMap(), "idle", (e) =>
      @setMap(@_idleMap) if @_idleMap
      @_idleMap = null

  bindExtraEvents: () ->
    @options.overlay.on "pathChanged", () =>
      @draw()

  unbindMarkerEvents: () =>
    google.maps.event.removeListener(@markerDragstartEvent)
    google.maps.event.removeListener(@markerDragendEvent)
      
  getPosition: () ->
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @left && @top)
      return overlayProjection.fromContainerPixelToLatLng({y: @top, x: @left})
    else
      return @options.overlay.getPosition()

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
      @getPanes().floatPane.appendChild @div
      
  draw: () ->
    overlayProjection = @getProjection()
    if (@getMap() && overlayProjection != null && overlayProjection != undefined && @options.overlay.getPosition() && @div)
      $(@div).css({position: "absolute", left: 0, top: 0})
      @divPixel = overlayProjection.fromLatLngToDivPixel(@options.overlay.getPosition())
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
      if @options.align == "bottom"
        bottom = (-1 * @top) # @divPixel.y
        # ( -1 * @top + $( @getMap().getDiv() ).height() )
        $(@div).css({left: @left, bottom: bottom, top: "auto"})
      else
        $(@div).css({left: @left, top: @top})

  redraw: (event) ->
    @draw()
  
  onRemove: () =>
    google.maps.event.removeListener(event) for event in @_events
    $(@div).remove() if @div
    @div = null if @div
    
  _onMarkerRemoved: () =>
    @setMap(null)
    
  _onOverlayIsOnMap: () =>
    @setMap(@options.overlay.getMap())
    @bindMarkerEvents()
    @bindExtraEvents()

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