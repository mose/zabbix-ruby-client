require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Apt
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        info = get_info
        if info
          back = []
          back << "#{host} apt[security] #{time} #{info[0]}"
          back << "#{host} apt[pending] #{time} #{info[1]}"
          back << "#{host} apt[status] #{time} TODO apt #{info[0]}/#{info[1]}"
          return back
        else
          return []
        end
      end

    private

      def get_info
        if os == :linux
          info = aptinfo
          if info
            back = info.split(/;/).map(&:to_i)
            back
          else
            false
          end
        end
      end

      def aptinfo
        output = `/usr/lib/update-notifier/apt-check 2>&1`
        if $?.to_i == 0
          Log.debug self
          Log.debug output
          output
        else
          Log.warn "Oh you don't have apt ?"
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('apt', ZabbixRubyClient::Plugins::Apt)

