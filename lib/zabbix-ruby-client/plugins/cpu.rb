# for more info check http://www.linuxhowtos.org/System/procstat.htm

class ZabbixRubyClient
  module Plugins
    module Cpu
      extend self

      def collect(*args)
        host = args[0]
        #cpuinfo = `mpstat | grep " all "`
        cpuinfo = `cat /proc/stat | grep "^cpu"`
        if $?.to_i == 0
          _, user, nice, sys, idle, wait, irq, soft, guest, steal = cpuinfo.split(/\s+/)
        else
          logger.warn "Oh you don't have a /proc ?"
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
        back << "#{host} cpu[total] #{user.to_i + nice + sys + wait + irq + soft + steal + guest + idle}"
        return back

      end

    end
  end
end

ZabbixRubyClient::Plugins.register('cpu', ZabbixRubyClient::Plugins::Cpu)
