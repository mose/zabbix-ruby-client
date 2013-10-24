# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/memory"

describe ZabbixRubyClient::Plugins::Memory do
  
  pending "populate a hash with extracted data"
  pending "splits info to prepare collection"

end