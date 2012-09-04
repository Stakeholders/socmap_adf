class ADF.Overlay.Views.Overlay extends ADF.GMap.Views.OverlayView
  
  constructor: (options) ->
    super(options)
    @map = options.map
    @point = options.point
    @pushOverlay()
    
  setTop: (top) ->
    @top = top
    @redraw()
  
  render: () ->
    $(@el).html(@template)
    @onRenderCompleted()
    return this

  hide: () ->
    @overlay.hide() if @overlay
    
  redraw: () ->
    @overlay.draw()

  pushOverlay: () ->
    @overlay = new ADF.GMap.Views.Overlay( @map.getGMap(), @ )
    @map.addOverlay(@overlay)

  setMarkerIcon: (icon) ->
    @icon = icon
    @overlay.setMarkerIcon()
    
  getMarkerIcon: () ->
    @overlay.getMarkerIcon()
    
  setLabel: (label) ->
    @label = label
    @overlay.setLabel()

  remove: () ->
    @overlay.setMap(null)

  center: () ->
    @overlay.map.setCenter(@point)
    
  canterPan: (x = 0, y = 0) ->
    @overlay.map.panTo(@point)
    @overlay.map.panBy(x, y)
    
  
  # Callback methods
  onRenderCompleted: () ->
  onMarkerAdded: () ->
  beforeMarkerClicked: () ->
  beforeOverlayShowed: () ->
  onOverlayShowed: () ->
