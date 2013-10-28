require "zabbix-ruby-client/logger"

class ZabbixRubyClient
  class Data

    def initialize(host)
      @discover = {}
      @items = []
      @host = host
    end

    def run_plugin(plugin, args = nil)
      Plugins.load(plugin) || logger.error( "Plugin #{plugin} not found.")
      if Plugins.loaded[plugin]
        begin
          @items += Plugins.loaded[plugin].send(:collect, @host, *args)
          if Plugins.loaded[plugin].respond_to?(:discover)
            key, value = Plugins.loaded[plugin].send(:discover, *args)
            @discover[key] ||= []
            @discover[key] << [ value ]
          end
        rescue Exception => e
          Log.fatal "Oops"
          Log.fatal e.message
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
