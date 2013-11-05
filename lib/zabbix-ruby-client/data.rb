require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"

module ZabbixRubyClient
  class Data

    def initialize(host)
      @discover = {}
      @items = []
      @host = host
    end

    def run_plugin(plugin, args = nil)
      Plugins.load(plugin) || ZabbixRubyClient::Log.error( "Plugin #{plugin} not found.")
      if Plugins.loaded[plugin]
        begin
          if Plugins.loaded[plugin].respond_to?(:collect)
            @items += Plugins.loaded[plugin].send(:collect, @host, *args)
          end
          if Plugins.loaded[plugin].respond_to?(:discover)
            key, value = Plugins.loaded[plugin].send(:discover, *args)
            @discover[key] ||= []
            @discover[key] << [ value ]
          end
        rescue Exception => e
          ZabbixRubyClient::Log.fatal "Oops"
          ZabbixRubyClient::Log.fatal e.message
        end
      end
    end

    def merge
      time = Time.now.to_i
      @discover.reduce([]) do |a,(k,v)|
        a << "#{@host} #{k} #{time} { \"data\": [ #{v.join(', ')} ] }"
        a
      end + @items
    end

  end
end
