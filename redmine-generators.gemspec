$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "redmine-generators/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "redmine-generators"
  s.version     = RedmineGenerators::VERSION
  s.authors     = ["Greg Thornton"]
  s.email       = ["xdissent@me.com"]
  s.homepage    = "http://xdissent.github.com/redmine-generators"
  s.summary     = "Helpful generators for Redmine plugin authors."
  s.description = "Helpful generators for Redmine plugin authors."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"

  s.add_development_dependency "sqlite3", "~> 1.3.7"
end
