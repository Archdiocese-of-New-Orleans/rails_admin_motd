$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_motd/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_motd"
  s.version     = RailsAdminMotd::VERSION
  s.authors     = ["David John"]
  s.email       = ["djohn@arch-no.org"]
  s.homepage    = "http://it.arch-no.org"
  s.summary     = "MOTD for your rails_admin instance"
  s.description = "A message of the day widget for rails_admin that uses Pusher for real time messaging."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency "pusher"
  s.add_dependency "cancan"

end
