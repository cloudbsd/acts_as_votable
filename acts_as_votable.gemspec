$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_votable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "acts_as_votable"
  gem.version     = ActsAsVotable::VERSION
  gem.authors     = ["Qi Li"]
  gem.email       = ["cloudbsd@gmail.com"]
  gem.homepage    = "http://github.com/cloudbsd/acts_as_votable"
  gem.summary     = "Acts As Votable Gem."
  gem.description = "ActsAsVotable gem provides a simple way to track users votes."
  gem.license     = 'MIT'

  gem.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
# gem.files       = `git ls-files`.split($/)
  gem.test_files = Dir["test/**/*"]
  gem.required_ruby_version     = '>= 1.9.3'

  gem.add_dependency 'rails',  ['>= 4.2', '< 6']
# gem.add_dependency 'activerecord',  ['>= 4.1', '< 5']

  gem.add_development_dependency "sqlite3"
end
