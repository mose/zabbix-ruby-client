# for more info check
# http://www.linuxhowtos.org/System/procstat.htm
# http://juliano.info/en/Blog:Memory_Leak/Understanding_the_Linux_load_average
require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Cpu
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        info = get_info
        back = []
        if info
          info.each do |k,v|
            back << "#{host} cpu[#{k}] #{time} #{v}"
          end
        end
        back
      end

    private

      def get_info
        ret = {}
        case os
        when :linux
          info = getline("/proc/stat", "^cpu ")
          if info
            back = info.split(/\s+/).map(&:to_i)
            ret["user"] = back[1]
            ret["nice"] = back[2]
            ret["system"] = back[3]
            ret["idle"] = back[4]
            ret["iowait"] = back[5]
            ret["irq"] = back[6]
            ret["soft"] = back[7]
            ret["steal"] = back[8] || 0
            ret["guest"] = back[9] || 0
            ret["used"] = back[1...4].reduce(&:+)
            ret["total"] = back[1...9].reduce(&:+)
            ret
          else
            false
          end
        when :unix
          info = iostat
          if info
            back = info.split(/\s+/).map(&:to_i)
            ret["user"] = back[12]
            ret["nice"] = back[13]
            ret["system"] = back[14]
            ret["idle"] = back[16]
            ret["iowait"] = back[15]
            ret["irq"] = 0
            ret["soft"] = 0
            ret["steal"] = 0
            ret["guest"] = 0
            ret["used"] = back[12..14].reduce(&:+)
            ret["total"] = back[12..16].reduce(&:+)
            ret
          else
            false
          end
        else
          false
        end
      end

      def iostat
        output = `/usr/sbin/iostat -C | tail -n 1`
        if $?.to_i == 0
          Log.debug self
          Log.debug output
          output
        else
          Log.warn "Oh there is no command."
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('cpu', ZabbixRubyClient::Plugins::Cpu)
