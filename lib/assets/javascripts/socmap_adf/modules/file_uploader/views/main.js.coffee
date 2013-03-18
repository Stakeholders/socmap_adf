class ADF.FileUploader.Views.Main extends ADF.MVC.Views.Base

  template: JST['socmap_adf/modules/file_uploader/templates/main']
  fileTemplate: JST['socmap_adf/modules/file_uploader/templates/file']
  existingFileTemplate: JST['socmap_adf/modules/file_uploader/templates/existing_file']
  fileUploadingTemplate: JST['socmap_adf/modules/file_uploader/templates/uploading']
  documents: []
  events:
    "click .remove-file" : "onFileRemoved"
  allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'gif']
  sizeLimit: 2024000
  message: ""
  action: '/api/documents'

  initialize: () ->
    _.bindAll(this, 'render')
    @documents = []
    @onComplete = @options.onComplete if @options.onComplete
    @onCancel = @options.onCancel if @options.onCancel
    @onProgressCallback = @options.onProgress if @options.onProgress
    @documents = @options.documents if @options.documents
    @allowedExtensions = @options.allowedExtensions if @options.allowedExtensions?
    @sizeLimit = @options.sizeLimit if @options.sizeLimit?
    @message = @options.message if @options.message?
    @template = @options.template if @options.template?
    @action = @options.action if @options.action?

  render: () ->
    options =
      element: $(@el).get(0)
      action: @action
      multiple: false
      debug: true
      allowedExtensions: @allowedExtensions
      onComplete: @onFileUploaded
      onProgress: @onProgress
      onSubmit: @onSubmit
      template: @template()
      sizeLimit: @sizeLimit
      
    if !@uploader
      @uploader = new qq.FileUploader options
    _.each @documents, (document) =>
      @addFileInList(document)
    
    @$(".file_upload_message").html(@message)
    @
    
  onFileUploaded: (id, fileName, responseJSON) =>
    @$(".file-list").find("#file-uploading-file-#{id}").remove()
    @documents.push responseJSON
    @addFileInList(responseJSON)
    if @onComplete
      @onComplete(@documents)

  onProgress: () =>
    @onProgressCallback() if @onProgressCallback
    
  onCancel: () =>

  onSubmit: (id, fileName) =>
    obj = {id: id, name: fileName}
    @$(".file-list").append(@fileUploadingTemplate(obj))

  addFileInList: (document) ->
    @$(".file-list").append(@fileTemplate(document))

  onFileRemoved: (e) =>
    e = e.currentTarget
    id =  $(e).attr("content-id")
    _.each @documents, (document) =>    
      if parseInt(document.id) == parseInt(id)
        document.remove = true
        @$("#file-uploaded-file-#{id}").remove()
        @onCancel()
    return false