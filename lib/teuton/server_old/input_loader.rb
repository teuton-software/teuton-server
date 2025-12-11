require 'yaml'
require_relative 'application'

# This module reads input configuration
module InputLoader
  # Read configuration
  # @param args [Array] List of arguments
  # @return [Hash]
  def self.read_configuration(args)
    input = (args.size.zero? ? [Application::CONFIGFILE] : args)
    param = {}
    param = read_yaml(input[0])
    param[:server][:ip] = input[1] if input[1]
    param[:server][:ip] = '127.0.0.1' if param[:server][:ip].nil?
    param[:server][:port] = input[2] if input[2]
    param[:server][:port] = Application::PORT if param[:server][:port].nil?
    param
  end

  # Read configuration from YAML file
  # @param filepath [String] Path to YAML file.
  # @return [Hash]
  def self.read_yaml(filepath)
    filepath = File.join(filepath,
               Application::CONFIGFILE) if File.directory? filepath
    unless File.exists? filepath
      puts Rainbow("[ERROR] Config file \'#{filepath}\' not found!").red
      exit 1
    end
    param = YAML.load_file(filepath)
    param[:server][:configfile] = filepath
    param[:server][:configdir] = File.dirname(filepath)
    param
  end
end
