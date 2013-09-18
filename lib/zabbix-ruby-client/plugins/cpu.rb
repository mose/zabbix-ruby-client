module ZabbixRubyClient
  module Plugins
    module Cpu
      extend self

      def collect(*args)
        host = args[0]
        cpuinfo = `mpstat | grep " all "`
        if $?.to_i == 0
          _, _, _, user, nice, sys, wait, irq, soft, steal, guest, idle = cpuinfo.split(/\s+/)
        else
          puts "Please install sysstat."
          return []
        end
        back = []
        back << "#{host} cpu[user] #{user}"
        back << "#{host} cpu[nice] #{nice}"
        back << "#{host} cpu[system] #{sys}"
        back << "#{host} cpu[iowait] #{wait}"
        back << "#{host} cpu[irq] #{irq}"
        back << "#{host} cpu[soft] #{soft}"
        back << "#{host} cpu[steal] #{steal}"
        back << "#{host} cpu[guest] #{guest}"
        back << "#{host} cpu[idle] #{idle}"
        return back

      end

    end
  end
end

ZabbixRubyClient.register_plugin('cpu', ZabbixRubyClient::Plugins::Cpu)
