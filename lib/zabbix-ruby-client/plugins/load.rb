# for more info check 
# http://juliano.info/en/Blog:Memory_Leak/Understanding_the_Linux_load_average
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"

module ZabbixRubyClient
  module Plugins
    module Load
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        info = get_info
        if info
          time = Time.now.to_i
          back = []
          back << "#{host} load[one] #{time} #{info[0]}"
          back << "#{host} load[five] #{time} #{info[1]}"
          back << "#{host} load[fifteen] #{time} #{info[2]}"
          back << "#{host} load[procs] #{time} #{info[3]}"
          return back
        else
          return []
        end
      end

    private

      def get_info
        info = getline("/proc/loadavg")
        if info
          back = info.split(/\s+/)
          back[3] = back[3].split(/\//)[0]
          back
        else
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('load', ZabbixRubyClient::Plugins::Load)
