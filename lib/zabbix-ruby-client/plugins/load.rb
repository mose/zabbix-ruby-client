# for more info check 
# http://juliano.info/en/Blog:Memory_Leak/Understanding_the_Linux_load_average

class ZabbixRubyClient
  module Plugins
    module Load
      extend self

      def collect(*args)
        host = args[0]
        #cpuinfo = `mpstat | grep " all "`
        cpuinfo = `cat /proc/loadavg`
        if $?.to_i == 0
          one, five, fifteen, procs_t = cpuinfo.split(/\s+/)
        else
          logger.warn "Oh you don't have a /proc ?"
          return []
        end

        procs, _ = procs_t.split(/\//)

        time = Time.now.to_i
        back = []
        back << "#{host} load[one] #{time} #{one}"
        back << "#{host} load[five] #{time} #{five}"
        back << "#{host} load[fifteen] #{time} #{fifteen}"
        back << "#{host} load[procs] #{time} #{procs}"
        return back

      end

    end
  end
end

ZabbixRubyClient::Plugins.register('load', ZabbixRubyClient::Plugins::Load)
