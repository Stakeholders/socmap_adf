ADF.Map.Views.Overlay ||= {}
ADF.Map.Views.Overlay.Content ||= {}

class ADF.Map.Views.Overlay.Content.Simple extends ADF.Map.Views.Overlay.Content.Abstract
  
  draw: () ->
    console.log @div
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
      $(@div).show()