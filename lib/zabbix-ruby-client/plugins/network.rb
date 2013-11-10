require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Network
      extend self

      def collect(*args)
        host = args[0]
        interface = args[1]
        info = get_info(interface)
        if info
          time = Time.now.to_i
          back = []
          back << "#{host} net.rx_ok[#{interface}] #{time} #{info[2]}"
          back << "#{host} net.rx_packets[#{interface}] #{time} #{info[3]}"
          back << "#{host} net.rx_err[#{interface}] #{time} #{info[4]}"
          back << "#{host} net.rx_drop[#{interface}] #{time} #{info[5]}"
          back << "#{host} net.tx_ok[#{interface}] #{time} #{info[10]}"
          back << "#{host} net.tx_packets[#{interface}] #{time} #{info[11]}"
          back << "#{host} net.tx_err[#{interface}] #{time} #{info[12]}"
          back << "#{host} net.tx_drop[#{interface}] #{time} #{info[13]}"
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
        info = netinfo(interface)
        if info
          info.split(/\s+/)
        else
          false
        end
      end

      def netinfo(interface)
        output = `grep "#{interface}: " /proc/net/dev`
        if $?.to_i == 0
          Log.debug self
          Log.debug output
          output
        else
          Log.warn "Oh you don't have /proc ?"
          false
        end
      end
      
    end
  end
end

ZabbixRubyClient::Plugins.register('network', ZabbixRubyClient::Plugins::Network)
