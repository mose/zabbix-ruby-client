module ZabbixRubyClient
  module Plugins
    module Cpu
      extend self

      def collect(*args)
        host = args[0]
        cpuinfo = `iostat -c | grep "^ "`
        _, user, nice, sys, wait, steal, idle = cpuinfo.split(/\s+/)
        back = []
        back << "#{host} cpu[user] #{user}"
        back << "#{host} cpu[nice] #{nice}"
        back << "#{host} cpu[system] #{sys}"
        back << "#{host} cpu[iowait] #{wait}"
        back << "#{host} cpu[steal] #{steal}"
        back << "#{host} cpu[idle] #{idle}"
        return back
      end

    end
  end
end
