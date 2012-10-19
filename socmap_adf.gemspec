$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "socmap_adf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "socmap_adf"
  s.version     = SocmapAdf::VERSION
  s.authors     = ["Arturs Braucs", "Edgars Kaukis", "Creative Mobile"]
  s.email       = ["arturs@creo.mobi"]
  s.homepage    = "https://github.com/CreativeMobile/"
  s.summary     = %q{Socmap App Design Framework}
  s.description = %q{Socmap App Design Framework - javascript + CSS}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rubyforge_project = "socmap_adf"
  s.add_dependency "rails"
  s.add_development_dependency "sqlite3"
end
