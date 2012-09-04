class ADF.GMap.Views.Marker extends google.maps.OverlayView

  in_zoom: false

  constructor: (map, point, content, width, height) ->
    @setMap(map)
    @point = point
    @content = content
    @width = width
    @height = height
    @bindMapEvents()

  onAdd: () =>
    @div = document.createElement("div")
    @div.innerHTML = this.content
    
    @div.style.border = "none"
    @div.style.borderWidth = "0px"
    @div.style.position = "absolute"
    
    @getPanes().overlayMouseTarget.appendChild(@div)
  
  draw: () =>
    if !@in_zoom
      overlayProjection = @getProjection()
      div_pixel = overlayProjection.fromLatLngToDivPixel(@point)
      
      left = div_pixel.x - (@width / 2)
      @div.style.left = left + 'px'
      top = div_pixel.y - (@height)
      @div.style.top = top + 'px'
      @show()
  
  change_point: (point) ->
    @point = point
    @draw()
  
  onRemove: () =>
    @div.parentNode.removeChild(@div)
    @div = null
    google.maps.event.removeListener(@zoom_changed_event)
    google.maps.event.removeListener(@idle_event)
  
  get_content: () ->
    return @div
  
  get_content_parent: () ->
    return $(@div).parent()

  hide: () ->
    $(@div).hide();
  
  show: () ->
    $(@div).show();

  bindMapEvents: () ->
    set_in_zoom = @set_in_zoom
    draw = @draw
    hide = @hide
    @idle_event = google.maps.event.addListener @map, 'tilesloaded', ->
      set_in_zoom(false)
      draw()

    @zoom_changed_event = google.maps.event.addListener @map, 'zoom_changed', ->
      set_in_zoom(true)
      hide()

  set_in_zoom: (val) ->
    @in_zoom = val

  is_in_zoom: () ->
    return @in_zoom