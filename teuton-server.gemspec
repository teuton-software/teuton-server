require_relative 'lib/teuton-server/application'

Gem::Specification.new do |s|
  s.name        = Application::NAME
  s.version     = Application::VERSION
  s.date        = '2020-02-17'
  s.summary     = "TeutonServer (Teuton Software project)"
  s.description = <<-EOF
  TeutonServer listen requests from TeutonClients.
  Responds executing Teuton evaluation for that client.
  EOF

  s.extra_rdoc_files = [ 'README.md', 'LICENSE' ] +
                       Dir.glob(File.join('docs','**','*.md'))

  s.license     = 'GPL-3.0'
  s.authors     = ['David Vargas Ruiz']
  s.email       = 'teuton.software@protonmail.com'
  s.homepage    = 'https://github.com/dvarrui/teuton-server'

  s.executables << 'teuton-server'
  s.files       = Dir.glob(File.join('lib','**','*.rb')) +
                  Dir.glob(File.join('lib','teuton-server','files','*'))

  s.add_runtime_dependency 'rainbow', '~> 3.0'
  s.add_runtime_dependency 'teuton', '~> 2.1', '>= 2.1.3'
  s.add_runtime_dependency "puma", "~> 7.1" # sinatra
  s.add_runtime_dependency "rackup", "~> 2.2" # sinatra
  s.add_runtime_dependency "sinatra", "~> 4.2" # sinatra

  s.add_development_dependency 'minitest', '~> 5.11' # TODO change by test-unit
end
