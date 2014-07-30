# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"

describe ZabbixRubyClient::PluginBase do

  before :all do
    @logfile = File.expand_path("../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
    @stubfile = File.expand_path('../../../spec/files/system/net_dev', __FILE__)
    @expected_line = "eth0: 8523363858 17554648    0    0    0     0          0    589997 2479556217 15780062    0    0    0     0       0          0"
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  after :each do
    FileUtils.rm "/tmp/xxxxx" if File.exists? "/tmp/xxxxx"
  end

  it "extracts a line from a file" do
    line = ZabbixRubyClient::PluginBase.getline(@stubfile, "eth0: ")
    expect(line).to eq @expected_line
  end

  it "logs a debug entry when it extracts a line from a file" do
    expect(ZabbixRubyClient::Log).to receive(:debug).with("File #{@stubfile}: #{@expected_line}")
    ZabbixRubyClient::PluginBase.getline(@stubfile, "eth0: ")
  end

  it "logs a warn entry when a line is not found in a file" do
    expect(ZabbixRubyClient::Log).to receive(:warn).with("File #{@stubfile}: pattern \" xxx \" not found.")
    x = ZabbixRubyClient::PluginBase.getline(@stubfile, " xxx ")
    expect(x).to be_falsey
  end

  it "logs an error entry when a file is not found" do
    expect(ZabbixRubyClient::Log).to receive(:error).with("File not found: /tmp/xxxxx")
    x = ZabbixRubyClient::PluginBase.getline("/tmp/xxxxx", " xxx ")
    expect(x).to be_falsey
  end

  it "logs an error entry when a file is not readable" do
    FileUtils.touch "/tmp/xxxxx"
    FileUtils.chmod 0300, "/tmp/xxxxx"
    expect(ZabbixRubyClient::Log).to receive(:error).with("File not readable: /tmp/xxxxx")
    x = ZabbixRubyClient::PluginBase.getline("/tmp/xxxxx", " xxx ")
    expect(x).to be_falsey
  end

end
