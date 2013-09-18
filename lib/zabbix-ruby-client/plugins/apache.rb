module ZabbixRubyClient
  module Plugins
    module Apache
      extend self

      def collect(*args)
        puts "Apache collecting..."
        return []
      end

    end
  end
end

ZabbixRubyClient.register_plugin('apache', ZabbixRubyClient::Plugins::Apache)
