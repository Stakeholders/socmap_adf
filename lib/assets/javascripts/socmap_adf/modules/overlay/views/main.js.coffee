class ADF.Overlay.Views.Main extends ADF.MVC.Views.Base
	
  template: JST['socmap_adf/modules/overlay/templates/main']
	    
  initialize: () ->
    _.bindAll(this, 'render')