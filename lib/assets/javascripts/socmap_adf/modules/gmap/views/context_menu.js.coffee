class ADF.GMap.Views.ContextMenu extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/gmap/templates/context_menu']
  pos: null
  
  constructor: (options) ->
    super(options)
    @gElement = options.gElement
    
  render: () ->
    $(@el).html(@template())
    $(@el).hide()
    $("body").append($(@el))
    google.maps.event.addDomListener @gElement, 'rightclick', @onRightClicked
    @
    
  show: () ->
    $(@el).show()
    
  onRightClicked: (e) =>
    @pos = e.pixel
    @show()
    console.log e