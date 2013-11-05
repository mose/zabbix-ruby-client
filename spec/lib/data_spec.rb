# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/data"
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/logger"

describe ZabbixRubyClient::Data do

  before :all do
    plugindir = File.expand_path("../../files/plugins", __FILE__)
    ZabbixRubyClient::Plugins.scan_dirs([plugindir])
  end

  it "initializes with host" do
    data = ZabbixRubyClient::Data.new("host")
    expect(data.instance_variable_get(:@host)).to eq "host"
  end

  it "runs a plugin" do
    data = ZabbixRubyClient::Data.new("host")
    plugin = "sample"
    items = ["localhost sample[foo] 123456789 42"]
    data.run_plugin(plugin)
    expect(data.instance_variable_get(:@items)).to eq items
  end

  it "logs an error when plugin is not found" do
    data = ZabbixRubyClient::Data.new("host")
    plugin = "unknown_plugin"
    expect(ZabbixRubyClient::Log).to receive(:error).with("Plugin #{plugin} not found.")
    data.run_plugin(plugin)
  end

  it "runs a plugin that only has discovery" do
    data = ZabbixRubyClient::Data.new("host")
    plugin = "sample_discover"
    discovery = { "sample.discover" => [["{\"{#SAMPLE}\": \"sample_arg\"}" ]]}
    data.run_plugin(plugin, 'sample_arg')
    expect(data.instance_variable_get(:@discover)).to eq discovery
  end

end
