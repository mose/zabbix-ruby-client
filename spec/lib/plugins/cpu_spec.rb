# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/cpu"

describe ZabbixRubyClient::Plugins::Cpu do
  
  pending "populate a hash with extracted data"

end