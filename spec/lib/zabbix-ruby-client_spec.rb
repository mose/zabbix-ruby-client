# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client"

describe ZabbixRubyClient do

  it "initialize the client object" do
    z = ZabbixRubyClient.new
    expect(z).to_be null
  end

  pending "creates dirs if needed"
  pending "loads list of plugins"
  pending "initialize datafile according to config"
  pending "stores data in datafile"
  pending "runs list of plugins according to config"
  pending "issues the upload command according to config"

end
