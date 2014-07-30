# read the /etc/openvpn/openvpn-status.log file
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"

module ZabbixRubyClient
  module Plugins
    module Ovpn
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        ovpnfile = args[1]
        info = get_info(ovpnfile)
        back = []
        if info
          time = Time.now.to_i
          back << "#{host} ovpn[received] #{time} #{info['received']}"
          back << "#{host} ovpn[sent] #{time} #{info['sent']}"
          back << "#{host} ovpn[count] #{time} #{info['count']}"
        end
        back
      end

    private

      def get_info(ovpnfile)
        ret = {}
        info = getlines(ovpnfile, "[^,]*,[^,]*,.* [0-9]{4}")
        if info
          received = 0
          sent = 0
          count = 0
          info.each do |line|
            if line[0] =~ /^[a-z]/
              back = line.split(',')
              received += back[2].to_i
              sent += back[3].to_i
              count += 1
            end
          end
          ret["received"] = received
          ret["sent"] = sent
          ret["count"] = count
          ret
        else
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('ovpn', ZabbixRubyClient::Plugins::Ovpn)
