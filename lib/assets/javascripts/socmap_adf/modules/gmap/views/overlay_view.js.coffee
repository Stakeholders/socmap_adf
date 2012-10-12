class ADF.GMap.Views.OverlayView extends ADF.MVC.Views.Base

  top: -60
  overlayPositionVertical: "top"
  left: 0
  hidden: true
  overlay: null
  icon: false
  shadow: false
  shape: false
  draggable: false
  point: false
  label: null
  labelClass: "marker_label"
  customMarker: null
  zindex: 1
  clickable: true
  asLabel: false
  showAfterDrag: false
  clustering: false
  data: 1

  constructor: (options) ->
    super(options)
    @map = options.map
    @point = options.point
    @clickable = options.clickable if options.clickable?
    @hidden = options.hidden if options.hidden?
    @data = options.data if options.data?
    
  setTop: (top) ->
    @top = top
    @redraw()
    
  setPosition: (top, left) ->
    @top = top
    @left = left
    @redraw()
  
  render: () ->
    if @model
      $(@el).html(@template(@model.toJSON()))
    else
      $(@el).html(@template)
    @initResize()
    @onRenderCompleted()
    @

  hide: () ->
    @overlay.hide() if @overlay
    
  show: () ->
    @overlay.show() if @overlay

  hideAll: () ->
    @hide()
    if @marker
      @marker.setMap(null)

  showAll: () ->
    @show()
    @overlay.initMarker()
    
  redraw: () ->
    @overlay.draw()

  isClustering: () ->
    @clustering

  getData: () ->
    @data

  pushOverlay: () ->
    @overlay = new ADF.GMap.Views.Overlay(@map.getGMap(), @)
    @map.addOverlay(@overlay)

  addOrChangeLocation: (point) ->
    @point = point
    if @overlay
      @overlay.setMap(null)
    else
      @unbindMap()
    @pushOverlay()

  setMarkerIcon: (icon) ->
    @icon = icon
    @overlay.setMarkerIcon()

  setDraggable: (draggable) ->
    @draggable = draggable
    @overlay.setDraggable(@draggable)

  setLabel: (label) ->
    @label = label
    @overlay.setLabel()

  remove: () ->
    @overlay.setMap(null) if @overlay
    @point = false
    @overlay = null

  getCustomMarker: () ->
    @customMarker

  setCustomMarker: (customMarker) ->
    @customMarker = customMarker
    @overlay.redrawMarker()
    
  getMarker: () ->
    @overlay.getMarker()

  getHeight: () ->
    $(@el).children(":first").height()
    
  getWidth: () ->
    $(@el).children(":first").width()

  initResize: () ->
    $(@el).children(":first").resize @onResize
    
  onResize: (e) =>
    @redraw()

  centerMap: () ->
    @overlay.centerToOverlay()
    
  centerPanMap: (x = 0, y = 0) ->
    @overlay.centerPanToOverlay(x, y)

  setMarker: (marker) ->
    @marker = marker

  # Callback methods
  onRenderCompleted: () ->
  onMarkerAdded: () ->
  beforeMarkerClicked: () ->
  beforeOverlayShowed: () ->
  onMarkerMouseOver: () ->
  onMarkerMouseOut: () ->
  onOverlayShowed: () ->
  onMarkerMoved: (point) ->
  unbindMap: () ->