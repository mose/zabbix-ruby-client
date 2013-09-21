# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.load_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/disk"

describe ZabbixRubyClient::Plugins::Disk do
  
  pending "populate a hash with extracted data"

end