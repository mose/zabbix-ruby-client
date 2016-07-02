require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"

module ZabbixRubyClient
  module Plugins
    module Memory
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        info = get_info
        if info
          back = []
          back << "#{host} memory[total] #{time} #{info['MemTotal']}"
          back << "#{host} memory[free] #{time} #{info['MemFree']}"
          back << "#{host} memory[used] #{time} #{info['MemUsed']}"
          back << "#{host} memory[percent_used] #{time} #{info['MemPercent']}"
          back << "#{host} memory[swap_total] #{time} #{info['SwapTotal']}"
          back << "#{host} memory[swap_free] #{time} #{info['SwapFree']}"
          back << "#{host} memory[swap_used] #{time} #{info['SwapUsed']}"
          back << "#{host} memory[swap_percent_used] #{time} #{info['SwapPercent']}"
          return back
        else
          return []
        end
      end

    private

      def get_info
        case os
        when :linux
          info = meminfo
          if info
            back = splitinfo(info)
            back["MemTotal"] = back["MemTotal"] * 1024
            back["MemFree"] = (back['MemFree'] + back['Buffers'] + back['Cached']) * 1024
            back["MemUsed"] = back["MemTotal"] - back["MemFree"]
            back["MemPercent"] = (back["MemUsed"] / back["MemTotal"].to_f * 100).to_i
            back['SwapTotal'] = back['SwapTotal'] * 1024
            back['SwapFree'] = back['SwapFree'] * 1024
            back['SwapUsed'] = back['SwapTotal'] - back['SwapFree']
            back['SwapPercent'] = 0
            unless back['SwapTotal'] == 0
              back['SwapPercent'] = (back['SwapUsed'] / back['SwapTotal'].to_f * 100).to_i
            end
            back
          else
            false
          end
        when :unix
          memtotal = `sysctl hw.realmem | cut -d' ' -f2`
          memused = `sysctl hw.usermem | cut -d' ' -f2`
          swap = `swapinfo | tail -n 1`
          _, _, swapused, swaptotal = *swap.split(/\s+/)
          back["MemTotal"] = memtotal
          back["MemFree"] = memtotal - memused
          back["MemUsed"] = memused
          back["MemPercent"] = (memused.to_i / memtotal.to_i * 100).to_i
          back['SwapTotal'] = swaptotal
          back['SwapFree'] = swaptotal - swapused
          back['SwapUsed'] = swapused
          back['SwapPercent'] = 0
          unless back['SwapTotal'] == 0
            back['SwapPercent'] = (swapused.to_i / swaptotal.to_i * 100).to_i
          end
          back
        else
          false
        end
      end

      def meminfo
        output = `cat /proc/meminfo`
        if $?.to_i == 0
          Log.debug self
          Log.debug output
          output
        else
          Log.warn "Oh there is no such device."
          false
        end
      end

      def splitinfo(info)
        info.split(/\n/).map(&:strip).reduce({}) do |a,line|
          _, key, value = *line.match(/^(\w+):\s+(\d+)\s/)
          a[key] = value.to_i if key
          a
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('memory', ZabbixRubyClient::Plugins::Memory)
