 # Requires
require "rails"

module SocmapAdf
  mattr_accessor :app_root
  
  mattr_accessor :assets
  @@assets = ["mvc", "map", "minimap", "gmap", "overlay", "overlay_push", "marker", "zone", "sidebar", "form", "popup", "image_uploader", "cluster", "file_uploader"]
  
  def self.setup
    yield self
  end
end

# Require our engine
require "socmap_adf/engine"
require "generators/install_generator"