# for more info check 
# http://www.linuxhowtos.org/System/procstat.htm
# http://juliano.info/en/Blog:Memory_Leak/Understanding_the_Linux_load_average

class ZabbixRubyClient
  module Plugins
    module Cpu
      extend self

      def collect(*args)
        host = args[0]
        cpuinfo = `cat /proc/stat | grep "^cpu"`
        if $?.to_i == 0
          _, user, nice, sys, idle, wait, irq, soft, guest, steal = cpuinfo.split(/\s+/).map(&:to_i)
        else
          logger.warn "Oh you don't have a /proc ?"
          return []
        end
        used = user + nice + sys
        total = used + idle

        time = Time.now.to_i
        back = []
        back << "#{host} cpu[user] #{time} #{user}"
        back << "#{host} cpu[nice] #{time} #{nice}"
        back << "#{host} cpu[system] #{time} #{sys}"
        back << "#{host} cpu[iowait] #{time} #{wait}"
        back << "#{host} cpu[irq] #{time} #{irq}"
        back << "#{host} cpu[soft] #{time} #{soft}"
        back << "#{host} cpu[steal] #{time} #{steal}"
        back << "#{host} cpu[guest] #{time} #{guest}"
        back << "#{host} cpu[idle] #{time} #{idle}"
        back << "#{host} cpu[used] #{time} #{used}"
        back << "#{host} cpu[total] #{time} #{total}"
        return back

      end

    end
  end
end

ZabbixRubyClient::Plugins.register('cpu', ZabbixRubyClient::Plugins::Cpu)
