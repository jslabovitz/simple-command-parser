Gem::Specification.new do |s|
  s.name          = 'simple-command-parser'
  s.version       = '1.1'
  s.summary       = 'A simple command parser.'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    Simple::CommandParser is a simple command parser.
  }.strip
  s.license       = 'MIT'
  s.homepage      = 'http://github.com/jslabovitz/simple-command-parser'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'simple_option_parser', '~> 0.8'

  s.add_development_dependency 'bundler', '~> 2.6'
  s.add_development_dependency 'minitest', '~> 5.22'
  s.add_development_dependency 'minitest-power_assert', '~> 0.3'
  s.add_development_dependency 'rake', '~> 13.3'
end