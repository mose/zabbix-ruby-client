class ZabbixRubyClient
  module Plugins
    module Network
      extend self

      def collect(*args)
        host = args[0]
        interface = args[1]
        netinfo = `netstat -i | grep "^#{interface} "`
        if $?.to_i == 0
          _, mtu, met, rx_ok, rx_err, rx_drop, rx_over, tx_ok, tx_err, tx_drop, tx_over, flags  = netinfo.split(/\s+/)
        else
          logger.warn "Please install netstat."
          return []
        end

        time = Time.mow.to_i
        back = []
        back << "#{host} net.mtu[#{interface}] #{time} #{mtu}"
        back << "#{host} net.met[#{interface}] #{time} #{met}"
        back << "#{host} net.rx_ok[#{interface}] #{time} #{rx_ok}"
        back << "#{host} net.rx_err[#{interface}] #{time} #{rx_err}"
        back << "#{host} net.rx_drop[#{interface}] #{time} #{rx_drop}"
        back << "#{host} net.rx_over[#{interface}] #{time} #{rx_over}"
        back << "#{host} net.tx_ok[#{interface}] #{time} #{tx_ok}"
        back << "#{host} net.tx_err[#{interface}] #{time} #{tx_err}"
        back << "#{host} net.tx_drop[#{interface}] #{time} #{tx_drop}"
        back << "#{host} net.tx_over[#{interface}] #{time} #{tx_over}"
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
