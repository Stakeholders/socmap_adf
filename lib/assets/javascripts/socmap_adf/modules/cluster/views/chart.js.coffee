class ADF.Cluster.Views.Chart extends ADF.MVC.Views.Base
  
  template: JST['socmap_adf/modules/cluster/templates/chart']
  position: null
  labelWidht: 15
  labelHeight: 15
  bigSize: 160
  mediumSize: 120
  smallSize: 80
  upLimit: 50
  currentSize: 120
  objectName: ""
  fillColors: ["#ff6700", "#0094ff", "#529900"]
  events:
    "mouseenter .chart_wrap": "onChartMouseOver"
    "mouseleave .chart_wrap": "onChartMouseOut"

  initialize: () -> 
    @data = @options.data
    @reports_count = @options.sum
    @setSize()
    @objectName = @options.objectName if @options.objectName
    @fillColors = @options.fillColors if @options.fillColors
    $.elycharts.templates['pie_basic_1'] =
      type: "pie"
      defaultSeries:
        plotProps:
          stroke: "white"
          "stroke-width": 1
          opacity: 0.9

  setSize: () ->
    count = if @reports_count then @reports_count.text else 1
    if count >= @upLimit
      @currentSize = @bigSize
    else
      @currentSize = @mediumSize
  
  onChartMouseOver: () =>
    @$(".chart").animate({opacity: 1}, 100)
    @$el.css({"z-index":10})
    
  onChartMouseOut: () =>
    @$(".chart").animate({opacity: 0.7}, 100)
    @$el.css({"z-index":5})
    
  render: () =>
    $(@el).html(@template({reports_count: @reports_count, objectName: @objectName }))
    @$(".chart_wrap").css
      position:"relative"
    @$(".chart").css
      height: @currentSize
      width: @currentSize
      opacity: 0.7
    lTop = (@currentSize / 2) - (@labelHeight / 2)
    lLeft = (@currentSize / 2) - (@labelWidht / 2)
    @$(".label").css
      position: "absolute"
      top: lTop
      left: lLeft
      background: "#000000"
      opacity: 0.8
      color:"#ffffff"
      "text-align": "center"
      "border-radius": 4
      "-moz-border-radius": 4
      "-webkit-border-radius": 4
      "font-size" : "13px"
      "line-height": "13px"
      "padding": "4px 6px"
    
    @hide()
    @onRenderCompleted()
    @
    
  onRenderCompleted: () ->
    @draw() if @position?
    @$(".chart").chart
      template: "pie_basic_1",
      values:
        serie1: @data
      defaultSeries:
        values: [
          {plotProps: { fill: @fillColors[0] }},
          {plotProps: { fill: @fillColors[1] }},
          {plotProps: { fill: @fillColors[2] }}
        ]
    
  setPosition: (position, draw = false) ->
    @position = position
    @draw() if draw
    
  draw: () ->
    if @position
      @$el.css
        cursor:"pointer"
        top: @position.y - (@currentSize / 2)
        left: @position.x - (@currentSize / 2)
        position:"absolute"
    @show()
    
  hide: () ->
    @$el.hide()
    
  show: () ->
    @$el.show() if @position

  
  