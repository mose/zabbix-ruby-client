require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/plugin_base"
require "zabbix-ruby-client/store"
require "zabbix-ruby-client/data"
require "zabbix-ruby-client/runner"
require "yaml"

module ZabbixRubyClient

  PLUGINDIR = File.expand_path("../zabbix-ruby-client/plugins", __FILE__)

end
