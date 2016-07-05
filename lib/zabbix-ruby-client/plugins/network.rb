require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"

module ZabbixRubyClient
  module Plugins
    module Network
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        interface = args[1]
        info = get_info(interface)
        if info
          back = []
          back << "#{host} net.rx_ok[#{interface}] #{time} #{info[:rx_ok]}"
          back << "#{host} net.rx_packets[#{interface}] #{time} #{info[:rx_packets]}"
          back << "#{host} net.rx_err[#{interface}] #{time} #{info[:rx_err]}"
          back << "#{host} net.rx_drop[#{interface}] #{time} #{info[:rx_drop]}"
          back << "#{host} net.tx_ok[#{interface}] #{time} #{info[:tx_ok]}"
          back << "#{host} net.tx_packets[#{interface}] #{time} #{info[:tx_packets]}"
          back << "#{host} net.tx_err[#{interface}] #{time} #{info[:tx_err]}"
          back << "#{host} net.tx_drop[#{interface}] #{time} #{info[:tx_drop]}"
          return back
        else
          return []
        end
      end

      def discover(*args)
        interface = args[0]
        [ "net.if.discovery", "{\"{#NET_IF}\": \"#{interface}\"}" ]
      end

    private

      def get_info(interface)
        back = {}
        case os
        when :linux
          data = getline("/proc/net/dev", "#{interface}:")
          if data
            info = data.split(/\s+/)
            back[:rx_ok] = info[1]
            back[:rx_packets] = info[2]
            back[:rx_err] = info[3]
            back[:rx_drop] = info[4]
            back[:tx_ok] = info[9]
            back[:tx_packets] = info[10]
            back[:tx_err] = info[11]
            back[:tx_drop] = info[12]
            return back
          else
            false
          end
        when :unix
          data = `/usr/bin/netstat -i -b -n -I #{interface} | tail -n 2 | head -n 1`
          if data
            info = data.split(/\s+/)
            back[:rx_ok] = info[6]
            back[:rx_packets] = info[4]
            back[:rx_err] = info[5].gsub(/-/, "0")
            back[:rx_drop] = info[6].gsub(/-/, "0")
            back[:tx_ok] = info[10]
            back[:tx_packets] = info[7]
            back[:tx_err] = info[8].gsub(/-/, "0")
            back[:tx_drop] = info[9].gsub(/-/, "0")
            return back
          else
            false
          end
        else
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('network', ZabbixRubyClient::Plugins::Network)
