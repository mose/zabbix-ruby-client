# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/data"
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/logger"

describe ZabbixRubyClient::Data do

  before :all do
    plugindir = File.expand_path("../../files/plugins", __FILE__)
    ZabbixRubyClient::Plugins.scan_dirs([plugindir])
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  before :each do
    @data = ZabbixRubyClient::Data.new("host")
  end

  after :all do 
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "initializes with host" do
    expect(@data.instance_variable_get(:@host)).to eq "host"
  end

  it "runs a plugin" do
    items = ["localhost sample[foo] 123456789 42"]
    @data.run_plugin("sample")
    expect(@data.instance_variable_get(:@items)).to eq items
  end

  it "logs an error when plugin is not found" do
    ZabbixRubyClient::Log.stub(:error).with("Plugin unknown_plugin not found.")
    @data.run_plugin("unknown_plugin")
  end

  it "runs a plugin that only has discovery" do
    discovery = { "sample.discover" => [["{\"{#SAMPLE}\": \"sample_arg\"}" ]]}
    @data.run_plugin("sample_discover", 'sample_arg')
    expect(@data.instance_variable_get(:@discover)).to eq discovery
  end

  it "ignores buggy plugins" do
    expect(@data.run_plugin("sample_buggy")).to be_true
  end

  it "logs buggy plugins" do
    ZabbixRubyClient::Log.stub(:fatal).with("Oops")
    ZabbixRubyClient::Log.stub(:fatal).with("Exception")
    @data.run_plugin("sample_buggy")
  end

  it "merges collected and discovered data" do
    Time.stub(:now).and_return("123456789")
    @data.run_plugin("sample")
    @data.run_plugin("sample_discover")
    result = ["host sample.discover 123456789 { \"data\": [ {\"{#SAMPLE}\": \"\"} ] }",
              "localhost sample[foo] 123456789 42"]
    expect(@data.merge).to eq result
  end

end
