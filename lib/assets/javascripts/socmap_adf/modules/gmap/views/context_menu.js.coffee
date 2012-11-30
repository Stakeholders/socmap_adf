class ADF.GMap.Views.ContextMenu extends ADF.MVC.Views.Base

  itemTemplate: JST['socmap_adf/modules/gmap/templates/context_menu_item']
  position: {x:null, y:null}
  latLng: null
  padding: 1
  paddingBoundryX: 10
  paddingBoundryY: 30
  menuItems: {}
  
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
    @$el.append('<div class="context_menu_background"></div>')
    @map.getMapElement().append($(@el))
    @rightClickEvent = google.maps.event.addListener @gElement, 'rightclick', @onRightClicked    
    @map.getMapElement().bind "mouseleave", @onMapMouseout
    $("body").bind "click", @onBodyClicked
    @
    
  unBind: () ->
    google.maps.event.removeListener(@rightClickEvent) if @rightClickEvent
    @map.getMapElement().unbind "mouseleave", @onMapMouseout
    $("body").unbind "click", @onBodyClicked
    @remove()
    
  show: () =>
    @calculatePosition()
    $(@el).show()
    @eventBus.trigger "ADF.GMap.Views.ContextMenu.isShowed"
    
  calculatePosition: () ->
    mW = @map.getMapElement().width()
    mH = @map.getMapElement().height()
    elW = $(@el).width()
    elH = $(@el).height()
    if ((mW - (@position.x + elW + @paddingBoundryX)) > 0)
      posX = @position.x + @padding
    else
      posX = @position.x - elW - @padding
    
    if ((mH - (@position.y + elH + @paddingBoundryY)) > 0)
      posY = @position.y + @padding
    else
      posY = @position.y - elH - @padding
    $(@el).css({"top" : posY, "left": posX})
    
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
    
  getItem: (title) ->
    @menuItems[title]

  bindItem: (title, callback) =>
    item = @itemTemplate({title : title})
    $(@el).append($(item))
    @menuItems[title] = $(@el).find(".menu_element").last()
    $(@el).find(".menu_element").last().bind "click", () =>
      callback(@latLng)
    @