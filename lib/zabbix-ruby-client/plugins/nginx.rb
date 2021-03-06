# uses http://wiki.nginx.org/HttpStubStatusModule
require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Nginx
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        info = get_status

        back = []
        back << "#{host} nginx[total] #{time} #{info[:total]}"
        back << "#{host} nginx[reading] #{time} #{info[:reading]}"
        back << "#{host} nginx[writing] #{time} #{info[:writing]}"
        back << "#{host} nginx[waiting] #{time} #{info[:waiting]}"
        back << "#{host} nginx[accepted] #{time} #{info[:accepted]}"
        back << "#{host} nginx[handled] #{time} #{info[:handled]}"
        back << "#{host} nginx[requests] #{time} #{info[:requests]}"
        return back
      end

      def get_status
        ret = {}
        open "http://127.0.0.1:8090/nginx_status" do |f|
          f.each_line do |line|
            ret[:total] = $1 if line =~ /^Active connections:\s+(\d+)/
            if line =~ /^Reading:\s+(\d+).*Writing:\s+(\d+).*Waiting:\s+(\d+)/
              ret[:reading] = $1
              ret[:writing] = $2
              ret[:waiting] = $3
            end
            ret[:accepted], ret[:handled], ret[:requests] = [$1, $2, $3] if line =~ /^\s+(\d+)\s+(\d+)\s+(\d+)/
          end
        end
        ret
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('nginx', ZabbixRubyClient::Plugins::Nginx)
