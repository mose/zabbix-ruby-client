class ZabbixRubyClient
  module Plugins
    module Network
      extend self

      def collect(*args)
        host = args[0]
        interface = args[1]
        netinfo = `grep "#{interface}: " /proc/net/dev`
        if $?.to_i == 0
          _, _, rx_ok, rx_packets, rx_err, rx_drop, _, _, _, _, tx_ok, tx_packets, tx_err, tx_drop, _, _, _, _  = netinfo.split(/\s+/)
        else
          logger.warn "Please install netstat."
          return []
        end

        time = Time.now.to_i
        back = []
        back << "#{host} net.rx_ok[#{interface}] #{time} #{rx_ok}"
        back << "#{host} net.rx_packets[#{interface}] #{time} #{rx_packets}"
        back << "#{host} net.rx_err[#{interface}] #{time} #{rx_err}"
        back << "#{host} net.rx_drop[#{interface}] #{time} #{rx_drop}"
        back << "#{host} net.tx_ok[#{interface}] #{time} #{tx_ok}"
        back << "#{host} net.tx_packets[#{interface}] #{time} #{tx_packets}"
        back << "#{host} net.tx_err[#{interface}] #{time} #{tx_err}"
        back << "#{host} net.tx_drop[#{interface}] #{time} #{tx_drop}"
        return back

      end

      def discover(*args)
        interface = args[0]
        [ "net.if.discovery", "{\"{#NET_IF}\": \"#{interface}\"}" ]
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('network', ZabbixRubyClient::Plugins::Network)
