class ADF.GMap.Views.ContextMenu extends ADF.MVC.Views.Base

  itemTemplate: JST['socmap_adf/modules/gmap/templates/context_menu_item']
  position: {x:null, y:null}
  latLng: null
  
  constructor: (options) ->
    super(options)
    @gElement = options.gElement
    @map = options.mapModel
    @eventBus.on "ADF.GMap.Views.ContextMenu.hide", @hide
    @overlay = new google.maps.OverlayView()
    @overlay.draw = () ->
    @overlay.setMap(@map.getGMap())
    
  render: () ->
    newElement = @make("div", {"class": "map_context_menu", "style" : "display:none;position:absolute;z-index:10;"} )
    @setElement( newElement )
    @map.getMapElement().append($(@el))
    google.maps.event.addDomListener @gElement, 'rightclick', @onRightClicked
    @map.getMapElement().bind "mouseleave", @onMapMouseout
    $("body").bind "click", @onBodyClicked
    @
    
  show: () ->
    $(@el).css({"top" : @position.y, "left": @position.x})
    $(@el).show()
    @eventBus.trigger "ADF.GMap.Views.ContextMenu.isShowed"
    
  hide: () =>
    $(@el).hide()
    @eventBus.trigger "ADF.GMap.Views.ContextMenu.isHidden"
    
  onRightClicked: (e) =>
    @eventBus.trigger "ADF.GMap.Views.ContextMenu.hide"
    @hide()

    point = @overlay.getProjection().fromLatLngToContainerPixel(e.latLng)
    @position = point
    @latLng = e.latLng
    @show()
    
  onBodyClicked: (e) =>
    @hide()
    
  onMapMouseout: (e) =>
    @hide()
    
  bindItem: (title, callback) =>
    item = @itemTemplate({title : title})
    $(@el).append($(item))
    $(@el).find(".menu_element").last().bind "click", () =>
      callback(@latLng)
    @