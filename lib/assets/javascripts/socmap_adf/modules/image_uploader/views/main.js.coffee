class ADF.ImageUploader.Views.Main extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/image_uploader/templates/main']
  image: null
  allowedExtensions: ['jpg', 'jpeg', 'png', 'gif']
  sizeLimit: 2024000
  events:
    "click .btn_close" : "onCloseClicked"

  initialize: () ->
    _.bindAll(this, 'render')
    @onComplete = @options.onComplete if @options.onComplete
    @onCancel = @options.onCancel if @options.onCancel
    @image = @options.image if @options.image
    @template = @options.template if @options.template
    @allowedExtensions = @options.allowedExtensions if @options.allowedExtensions?
    @sizeLimit = @options.sizeLimit if @options.sizeLimit?
    
  render: () ->
    options =
      element: $(@el).get(0)
      action: '/api/images'
      multiple: false
      debug: true
      allowedExtensions: @allowedExtensions
      onComplete: @onFileUploaded
      onProgress: @onProgress
      template: @template()
      sizeLimit: @sizeLimit
      messages_lv:
        typeError: "Failam {file} ir nepareizs formāts. Tikai {extensions} formāti ir atļauti."
        sizeError: "Fails {file} ir pārāk liels. Faila maksimālais lielums {sizeLimit}."
        minSizeError: "Faila {file} izmērs ir par mazu, minimums {minSizeLimit}."
        emptyError: "Fails {file} ir tukšs."
        onLeave: "Fails nav pabeidzis augšuplādi. Vai tiešām vēlaties pamest aplikāciju?"

    if !@uploader
      @uploader = new qq.FileUploader options
    @$("ul").hide()
    
    if @image
      @showImage(@image)
    else
      @$(".btn_close").hide()
      @$(".image_holder").show()
    @

  onProgress: () =>
    @$(".btn_close").hide()
    @$(".image_holder").hide()
    @$('.loading').show()

  onFileUploaded: (id, fileName, responseJSON) =>
    @$('.loading').hide()
    @$(".image_holder").hide()
    @image = responseJSON.uploader_url
    @showImage(@image)
    @$(".btn_close").show()
    @onComplete(responseJSON) if @onComplete

  onCloseClicked: () ->
    @$(".uploaded_picture").hide()
    @$(".btn_close").hide()
    @$(".image_holder").show()
    @onCancel() if @onCancel
    return false

  showImage: (image_url) ->
    @$(".image_holder").hide()
    @$(".uploaded_picture").attr("src", image_url)
    @$(".uploaded_picture").show()