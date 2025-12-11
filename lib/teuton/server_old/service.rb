require 'socket'

##
# This class wake up service to respond request from 1 client.
class Service
  ##
  # Run 1 service to respond request from 1 client.
  # @param param [Hash] Service params
  def run(param)
    service = TCPServer.open(param[:server][:port])
    accept_clients service, param
  end

  private

  def accept_clients(service, param)
    puts Rainbow("teuton-server => service [#{param[:client][:id]}] " +
         "listening on \'#{param[:server][:port]}\'...").bright
    #puts "                 #{service.addr}"
    @actions = []
    @testindex = 0
    loop {
      client = service.accept
      if authorized_request?(client, param)
        @actions << accept_request(client, param, @testindex)
      else
        @actions << deny_request(client, param)
      end
    }
  end

  def authorized_request?(client, param)
    if param[:client][:ip] == :allow
      param[:client][:ip] = client.peeraddr[2]
      return true
    end
    return false if param[:client][:ip] == :deny
    return param[:client][:ip] == client.peeraddr[2]
  end

  def deny_request(client, param)
    puts Rainbow("teuton-server => service [#{param[:client][:id]}] " +
         "listening on \'#{param[:server][:port]}\'...").bright
    puts "                 " +
         Rainbow("WARN: Request not authorized " +
         "\'#{client.peeraddr[2]}:#{param[:server][:port]}\'").yellow
    client.puts Rainbow('Request denied from TeutonServer!').yellow
    client.close
    action = {}
    action[:timestamp] = Time.now
    action[:status] = 'Request denied'
    action
  end

  def accept_request(client, param, testindex)
    action = run_local_action(param, testindex)
    respond_to_client client, param, action
    action
  end

  def run_local_action(param, testindex)
    testname = param[:server][:testunits][testindex]
    file = File.join(param[:server][:configdir], testname)
    id = param[:client][:id]
    command = "teuton play --quiet --case=#{id} #{file}"
    ok = system(command)
    action = {}
    action[:timestamp] = Time.now
    action[:testname] = testname
    action[:cmd] = command
    action[:grade] = Rainbow('FAIL!').red
    action[:grade] = get_grade_from_report(param, testindex) if ok
    action
  end

  def get_grade_from_report(param, testindex)
    testname = param[:server][:testunits][testindex]
    id = param[:client][:id]
    id_tos = (id > 9 ? id.to_s : format('%02d',id))
    report_path = File.join('var', testname, "case-#{id_tos}.txt")
    return 'Unkown' unless File.exists? report_path
    grade = `cat #{report_path} | grep grade`
    grade.chop!.gsub!('|','').gsub!(' ','').gsub!('grade','')
    return grade
  end

  def respond_to_client(client, param, action)
    #puts "                 ADDR        : #{client.addr}"
    #puts "                 PEERADDR    : #{client.peeraddr}"
    puts Rainbow("teuton-server => working...   " +
         "service[#{param[:client][:id]}]").bright
    src = "#{param[:server][:ip]}:#{param[:server][:port]}"
    dest = "#{param[:client][:ip]}:#{client.peeraddr[1]}"
    tab = '                 '

    output = tab + "Members    : #{param[:client][:members]}\n" +
             tab + "Connection : #{src} -> #{dest}\n" +
             tab + "Timestamp  : #{action[:timestamp]}\n" +
             tab + "Action     : #{action[:cmd]}\n" +
             tab + "Grade      : #{action[:grade]}\n"
    puts output
    client.puts("Connection : #{src} -> #{dest} ")
    client.puts("Timestamp  : #{action[:timestamp]}")
    client.puts("Test Name  : #{action[:testname]}")
    client.puts("Grade      : #{action[:grade]}")
    client.close
  end
end
