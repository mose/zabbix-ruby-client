# for more info check
# http://www.linuxhowtos.org/System/procstat.htm
# http://juliano.info/en/Blog:Memory_Leak/Understanding_the_Linux_load_average
require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Cpu
      extend self

      def collect(*args)
        host = args[0]
        info = get_info
        if info
          time = Time.now.to_i
          back = []
          back << "#{host} cpu[user] #{time} #{info[1]}"
          back << "#{host} cpu[nice] #{time} #{info[2]}"
          back << "#{host} cpu[system] #{time} #{info[3]}"
          back << "#{host} cpu[iowait] #{time} #{info[4]}"
          back << "#{host} cpu[irq] #{time} #{info[5]}"
          back << "#{host} cpu[soft] #{time} #{info[6]}"
          back << "#{host} cpu[steal] #{time} #{info[7]}"
          back << "#{host} cpu[guest] #{time} #{info[8]}"
          back << "#{host} cpu[idle] #{time} #{info[9]}"
          back << "#{host} cpu[used] #{time} #{info[10]}"
          back << "#{host} cpu[total] #{time} #{info[11]}"
          return back
        else
          return []
        end
      end

    private

      def get_info
        info = cpuinfo
        if info
          back = info.split(/\s+/).map(&:to_i)
          back << back[1] + back[2] + back[3]
          back << back[10] + back[9]
          back
        else
          false
        end
      end

      def cpuinfo
        output = `cat /proc/stat | grep "^cpu"`
        if $?.to_i == 0
          Log.debug self
          Log.debug output
          output
        else
          Log.warn "Oh you don't have a /proc ?"
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('cpu', ZabbixRubyClient::Plugins::Cpu)
