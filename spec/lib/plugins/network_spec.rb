# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.load_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/network"

describe ZabbixRubyClient::Plugins::Network do
  
  pending "populate a hash with extracted data"

end