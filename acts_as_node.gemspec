$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_node/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_node"
  s.version     = '0.0.2'
  s.authors     = ["Jinzhu"]
  s.email       = ["wosmvp@gmail.com"]
  s.homepage    = "https://github.com/jinzhu/acts_as_node"
  s.summary     = "ActsAsNode"
  s.description = "ActsAsNode"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"

  s.add_development_dependency "sqlite3"
end
