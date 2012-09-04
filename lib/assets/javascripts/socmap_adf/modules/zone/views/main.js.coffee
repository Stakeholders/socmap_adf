class ADF.Zone.Views.Main extends ADF.MVC.Views.Base
	
  template: JST['socmap_adf/modules/zone/templates/main']
	    
  initialize: () ->
    _.bindAll(this, 'render')