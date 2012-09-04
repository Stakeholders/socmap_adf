# Requires
require 'rails/generators'

module SocmapAdf
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      desc "Installs SocmapAdf"

      def copy_initializer
        template 'socmap.rb.erb', 'config/initializers/socmap_adf.rb'
      end
    end
  end
end