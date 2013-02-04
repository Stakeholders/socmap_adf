# THIS IS DEPRICATED, still used in app [ NEW POPUP ir MAiN ]

class ADF.Popup.Views.Basic extends ADF.MVC.Views.Base

  # Assign view options
  class           : "popup_wrap"
  backgroundClass : "popup_background"
  category        : "other"
  isClosable      : true
  hasBackground   : true
  insidePosition  : "center"
  horizontalAlign : "center"
  verticalAlign   : "top"
  horizontalOffset: 0
  verticalOffset  : 70
  widthOffset: 0
  
  # Render view
  render: () ->
    if @model
      $(@el).hide().html( @template( @model.toJSON() ) ).addClass( @class ).fadeIn(300)
    else
      $(@el).hide().html( @template() ).addClass( @class ).fadeIn(300)
    
    if @insidePosition == "center"
      $(@el).addClass( "center" )
    
    $("body").append( $("<div>", {"id": "popups"} ) ) if !$("#popups").length
    
    if @category
      if !$("#popups").find( "#" + @category + "_popups" ).length
        $("#popups").append( $("<div>", { "id": @category + "_popups" } ) )
      
      $("#" + @category + "_popups").append( @el )
    else
      $("#popups").append( @el )
    
    if !$("#popups ." + @backgroundClass).length
      @backgroundElement = $("<div>", { "class": @backgroundClass } )
      $("#popups").append( @backgroundElement )
    
    @showBackground() if @hasBackground == true
    @renderPosition()
    $(window).bind( "resize", @renderPosition )
    
    return @
  
  # Render methods
  showBackground: () ->
    $("." + @backgroundClass).fadeIn(500)
    $("." + @backgroundClass).bind( "click", @closeClicked ) if @isClosable == true
  
  renderPosition: () =>
    windowHeight = $(window).height()
    windowWidth = $(window).width()
    elHeight = $(@el).height()
    elWidth = $(@el).width() + @widthOffset
    
    if @verticalAlign == "top"
      top = @verticalOffset
    else if @verticalAlign == "bottom"
      top =  windowHeight - elHeight - @verticalOffset
    else
      offsetTop = ((elHeight + @verticalOffset) / 2)
      top =  windowHeight / 2
      top = top - offsetTop
    
    if @horizontalAlign == "left"
      left = @horizontalOffset
    else if @horizontalAlign == "right"
      left = windowWidth - elWidth - @horizontalOffset
    else
      left = (windowWidth + @horizontalOffset) / 2
      offsetLeft = (elWidth / 2)
      left = left - offsetLeft
    
    $(@el).css({top: top, left: left})
  
  # View event methods
  closeClicked: ( event ) =>
    event.preventDefault()
    @destroy()
  
  destroy: () ->
    @beforeDestroy()
    $(@el).fadeOut( 200, -> $(@).remove() )
    $(@backgroundElement).fadeOut(400) if @hasBackground == true
    
  beforeDestroy: () ->
  onRenderCompleted: () -> 
