
require_relative '../teuton-server'

##
# Command line interface module
module CLI
  ##
  # Start application
  # @params argv (ARGV)
  def self.start(argv)
    TeutonServer.show_help if argv.first == 'help'
    TeutonServer.show_version if argv.first == 'version'
    TeutonServer.init(argv.slice(1,argv.size)) if argv.first == 'init'
    TeutonServer.start(argv)
  end
end
