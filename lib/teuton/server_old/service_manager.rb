
require_relative 'service'

# This module start a group of services. One for every client.
# Every service listen on diferent ports. For example:
# * service 1 listen on port PORT+1, client 1 requests.
# * service 2 listen on port PORT+2, client 2 requests.
# * etc.
module ServiceManager
  class << self
    # Start one service for every client.
    # @param app_param [Hash] Application configuration params
    # @return [Exit status] Exit 0 = OK. Exit 1 = ERROR
    def start_services(app_param)
      show_starting(app_param)
      services_param = split_app_param_into_services_param(app_param)
      services = []
      begin
       services_param.each do |param|
          services << Thread.new{ Service.new.run(param) }
        end
        services.each { |service| service.join }
      rescue SystemExit, Interrupt
        puts Rainbow("\nteuton-server => Closing...").bright
        exit 0
      end
    end

    private

    def show_starting(param)
      puts Rainbow("teuton-server => Starting...").bright
      puts "                 Configfile : #{param[:server][:configfile]}"
      puts "                 Listen on  : #{param[:server][:ip]}:#{param[:server][:port]}"
      puts "                 Test list  : #{param[:server][:testunits].join(',')}"
      puts Rainbow("                 (CTRL+C to exit)").bright.yellow
    end

    def split_app_param_into_services_param(app_param)
      services_param = []
      app_param[:clients].each_with_index do |client, index|
        param = { server: {}, client: {} }
        param[:server].merge! app_param[:server] if app_param[:server]
        param[:server][:hostname] = param[:server][:ip]
        param[:client].merge! client
        param[:client][:id] = index + 1
        param[:server][:port] += param[:client][:id]
        services_param << param
      end
      services_param
    end
  end
end
