class ZabbixRubyClient
  module Plugins
    module Memory
      extend self

      def collect(*args)
        host = args[0]
        meminfo = `cat /proc/meminfo`
        if $?.to_i == 0
          info = splitinfo(meminfo)
        else
          logger.warn "Please install sysstat."
          return []
        end

        mem_total = info["MemTotal"] * 1024
        mem_free = (info['MemFree'] + info['Buffers'] + info['Cached']) * 1024
        mem_used = mem_total - mem_free
        mem_percent = (mem_used / mem_total.to_f * 100).to_i
        swap_total = info['SwapTotal'] * 1024
        swap_free = info['SwapFree'] * 1024
        swap_used = swap_total - swap_free
        swap_percent = 0
        unless swap_total == 0
          swap_percent = (swap_used / swap_total.to_f * 100).to_i
        end

        time = Time.now.to_i
        back = []
        back << "#{host} memory[total] #{time} #{mem_total}"
        back << "#{host} memory[used] #{time} #{mem_used}"
        back << "#{host} memory[free] #{time} #{mem_free}"
        back << "#{host} memory[percent_used] #{time} #{mem_percent}"
        back << "#{host} memory[swap_total] #{time} #{swap_total}"
        back << "#{host} memory[swap_used] #{time} #{swap_used}"
        back << "#{host} memory[swap_free] #{time} #{swap_free}"
        back << "#{host} memory[swap_percent_used] #{time} #{swap_percent}"
        return back
      end

      def splitinfo(info)
        info.split(/\n/).map(&:strip).reduce({}) do |a,line|
          _, key, value = *line.match(/^(\w+):\s+(\d+)\s/)
          a[key] = value.to_i
          a
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('memory', ZabbixRubyClient::Plugins::Memory)
