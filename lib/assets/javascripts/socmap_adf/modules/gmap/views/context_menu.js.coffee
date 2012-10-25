class ADF.GMap.Views.ContextMenu extends ADF.MVC.Views.Base

  itemTemplate: JST['socmap_adf/modules/gmap/templates/context_menu_item']
  position: {x:null, y:null}
  latLng: null
  
  constructor: (options) ->
    super(options)
    @gElement = options.gElement
    @map = options.mapModel
    @eventBus.on "adf.hideContextMenu", @hide
    
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
    
  hide: () =>
    $(@el).hide()
    
  onRightClicked: (e) =>
    @eventBus.trigger "adf.hideContextMenu"
    @hide()
    @position = if e.pixel then e.pixel else {x:e.b.x-420, y:e.b.y-20 }
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