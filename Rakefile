require 'rubygems'
require 'rake/gempackagetask'

require 'merb-core'
require 'merb-core/tasks/merb'

GEM_NAME    = "merb_messenger"
GEM_VERSION = "0.0.1"
AUTHOR      = "Michael Klishin"
EMAIL       = "michael@novemberain.com"
HOMEPAGE    = "http://merbivore.com/"
SUMMARY     = "Merb plugin that provides messaging/notifications functionality: from email and XMPP to AMPQ and beyond."

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb'
  s.name              = GEM_NAME
  s.version           = GEM_VERSION
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = false
  s.extra_rdoc_files  = ["README", "LICENSE", 'TODO']
  s.summary           = SUMMARY
  s.description       = SUMMARY
  s.author            = AUTHOR
  s.email             = EMAIL
  s.homepage          = HOMEPAGE
  s.add_dependency('merb', '>= 0.9.10')
  s.require_path      = 'lib'
  s.files             = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
  
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the plugin as a gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end