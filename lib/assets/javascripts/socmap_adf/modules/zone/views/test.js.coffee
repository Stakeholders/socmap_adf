class ADF.Zone.Views.Test extends ADF.MVC.Views.Base
  
  initialize: (map) ->
    @map = map
    
  startTest: (zone) ->
    @zone = zone
    
    @marker = new google.maps.Marker
      map:@map,
      draggable:true,
      animation: google.maps.Animation.DROP,
      position: @zone.getPointByOrder(0)
    
    google.maps.event.addListener(@marker, 'dragend', @dragendMarker);    
  
  dragendMarker: (e) =>