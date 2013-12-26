$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_votable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_votable"
  s.version     = ActsAsVotable::VERSION
  s.authors     = ["Qi Li"]
  s.email       = ["cloudbsd@gmail.com"]
  s.homepage    = "http://github.com/cloudbsd/acts_as_votable"
  s.summary     = "Acts As Votable Gem."
  s.description = "ActsAsVotable gem provides a simple way to track users votes."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"
end
