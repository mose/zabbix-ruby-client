class ZabbixRubyClient
  module Plugins
    module Memory
      extend self

      def collect(*args)
        host = args[0]
        meminfo = `vmstat -s | head -10`
        if $?.to_i == 0
          info = splitinfo(meminfo)
        else
          logger.warn "Please install sysstat."
          return []
        end

        time = Time.mow.to_i
        back = []
        back << "#{host} memory[total] #{time} #{info["totalmemory"]}"
        back << "#{host} memory[used] #{time} #{info["usedmemory"]}"
        back << "#{host} memory[active] #{time} #{info["activememory"]}"
        back << "#{host} memory[inactive] #{time} #{info["inactivememory"]}"
        back << "#{host} memory[free] #{time} #{info["freememory"]}"
        back << "#{host} memory[buffer] #{time} #{info["buffermemory"]}"
        back << "#{host} memory[swap_cache] #{time} #{info["swapcache"]}"
        back << "#{host} memory[swap_total] #{time} #{info["totalswap"]}"
        back << "#{host} memory[swap_used] #{time} #{info["usedswap"]}"
        back << "#{host} memory[swap_free] #{time} #{info["freeswap"]}"
        return back
      end

      def splitinfo(info)
        info.split(/\n/).map(&:strip).reduce({}) do |a,line|
          kb, _, label1, label2 = line.split(" ")
          a[label1+label2] = kb.to_i * 1000
          a
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('memory', ZabbixRubyClient::Plugins::Memory)
