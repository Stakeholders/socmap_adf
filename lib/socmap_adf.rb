 # Requires
require "rails"

module SocmapAdf
  mattr_accessor :app_root
  
  mattr_accessor :assets
  @@assets = ["mvc", "popup", "map", "minimap", "gmap", "overlay", "overlay_push", "marker", "zone", "sidebar", "form", "login", "image_uploader", "file_uploader"]
  
  def self.setup
    yield self
  end
end

# Require our engine
require "socmap_adf/engine"
require "generators/install_generator"