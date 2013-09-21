# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.load_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/apache"

describe ZabbixRubyClient::Plugins::Apache do
  
  pending "gets the status page from localhost"
  pending "populate a hash with extracted data"
  pending "populate scores from scoreboard data"

end