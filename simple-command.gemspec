require_relative 'lib/simple-command/version'

Gem::Specification.new do |s|
  s.name          = 'simple-command'
  s.version       = SimpleCommand::VERSION
  s.summary       = 'A simple command processor.'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    SimpleCommand is a simple command processor.
  }.strip
  s.license       = 'MIT'
  s.homepage      = 'http://github.com/jslabovitz/simple-command'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'hashstruct', '~> 1.3'
  s.add_dependency 'simple_option_parser', '~> 0.3'

  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rubygems-tasks', '~> 0.2'
end