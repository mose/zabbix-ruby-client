# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/plugins/cpu"

describe ZabbixRubyClient::Plugins::Cpu do

  it "populate a hash with extracted data" do
    ZabbixRubyClient::Plugins.run('cpu')
  end

end
