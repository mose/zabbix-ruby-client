module ZabbixRubyClient
  module Plugins
    module Network
      extend self

      def collect(*args)
        host = args[0]
        interface = args[1]
        netinfo = `netstat -i | grep "^#{interface} "`
        if $?.to_i == 0
          _, mtu, rx_ok, rx_err, rx_drop, rx_over, tx_ok, tx_err, tx_drop, tx_over, flags  = netinfo.split(/\s+/)
        else
          logger.warn "Please install netstat."
          return []
        end
        back = []
        back << "#{host} net[#{interface},mtu] #{mtu}"
        back << "#{host} net[#{interface},rx_ok] #{rx_ok}"
        back << "#{host} net[#{interface},rx_err] #{rx_err}"
        back << "#{host} net[#{interface},rx_drop] #{rx_drop}"
        back << "#{host} net[#{interface},rx_over] #{rx_over}"
        back << "#{host} net[#{interface},tx_ok] #{tx_ok}"
        back << "#{host} net[#{interface},tx_err] #{tx_err}"
        back << "#{host} net[#{interface},tx_drop] #{tx_drop}"
        back << "#{host} net[#{interface},tx_over] #{tx_over}"
        return back

      end

    end
  end
end

ZabbixRubyClient.register_plugin('network', ZabbixRubyClient::Plugins::Network)
