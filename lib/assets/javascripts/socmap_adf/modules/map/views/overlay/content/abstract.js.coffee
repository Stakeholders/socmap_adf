ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Abstract extends google.maps.OverlayView
  
  padding: 30
  zindex: 1

  constructor: (options) ->
    @options = options
    @setMap(@options.marker.getMap())
    @bindMarkerEvents()
    @bindMapEvents()
    @draw()

  bindMarkerEvents: () ->
    
  unbindMarkerEvents: () =>

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

  draw: () ->
    overlayProjection = @getProjection()
    if (overlayProjection != null && overlayProjection != undefined && @options.marker.getPosition() && @div)
      @divPixel = overlayProjection.fromLatLngToContainerPixel(@options.marker.getPosition())
      markerSize = @options.marker.options.icon.size
      markerWidth = markerSize.width
      markerHeight = markerSize.height
      overlayWidth = $(@div).width()
      overlayHeight = $(@div).height()
      
      @left = @divPixel.x - overlayWidth - @padding
      @top = @divPixel.y - markerHeight
        
    if (@div)
      $(@div).css({position: "absolute", left: @left, top: @top, "z-index" : @zindex})

  redraw: (event) ->
    @draw()
  
  onRemove: () ->
    @unbindMapEvents()
    @unbindMarkerEvents()
    $(@div).remove() if @div

  setInFront: () ->
    @zindex = @zindex + 1
    @draw()

  setBack: () ->
    @zindex = @zindex - 1
    @draw()