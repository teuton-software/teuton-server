require 'fileutils'
require 'rainbow'
require_relative 'teuton-server/application'
require_relative 'teuton-server/input_loader'
require_relative 'teuton-server/service_manager'

##
# TeutonServer has these main actions:
# * help    => show_help
# * version => show_version
# * init    => init or create server config file
# * start   => Start Teuton Server
module TeutonServer
  ##
  # Start TeutonServer arguments:
  # * No arguments => start server with default config file (teuton-server.yaml).
  # * Directory => start server with default config file (DIR/teuton-server.yaml).
  # * YAML file => start server with config file (file.yaml).
  # @param args [Array] List of arguments
  def self.start(args)
    param = InputLoader.read_configuration(args)
    ServiceManager.start_services(param)
  end

  # Show TeutonServer help
  def self.show_help
    puts "Usage:"
    puts "    teuton-server [help|version] [PATH/TO/server.yaml [IP]]"
    puts "Params:"
    puts "    help      , Show this help"
    puts "    version   , Show current version"
    puts "    init      , Create server.yaml config file"
    puts "    CONFIGFILE, YAML server configuration file"
    puts "Example:"
    puts "    teuton-server server.yaml 192.168.1.16 " +
              "# Start TeutonServer using 192.168.1.16 IP:"
    puts "    teuton-server init foo/config.yaml     " +
              "# Create config file"
    exit 0
  end

  # Show TeutonServer version
  def self.show_version
    puts "teuton-server => " + Rainbow("version #{Application::VERSION}").cyan
    exit 0
  end

  # Create default configuration file. Arguments:
  # * "" => Create default config file (teuton-server.yaml)
  # * "DIR" => Create DIR/teuton-server.yaml config file.
  # * "FILE.yaml" => Create FILE.yaml config file.
  # @param args [Array] List of arguments, where args.first = 'init'
  def self.init(args)
    src = File.join(File.dirname(__FILE__),
          'teuton-server', 'files', Application::CONFIGFILE)
    dest = File.join(Application::CONFIGFILE)

    if args.size > 0
      file = args.first
      dest = File.join(file) if File.extname(file) == '.yaml'
      dest = File.join(file, Application::CONFIGFILE) if File.directory? file
    end
    if File.exists? dest
      puts "teuton-server => " + Rainbow("File \'#{dest}\' exists!").red
      exit 1
    end
    FileUtils.cp(src, dest)
    puts "teuton-server => " + Rainbow("Init \'#{dest}\' done!").yellow
    exit 0
    # TODO:
    # Add testunits list by default
    # a = Dir.glob(File.join('projects/gnulinux-basic/**','start.rb'))
  end
end
