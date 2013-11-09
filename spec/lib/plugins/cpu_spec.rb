# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/cpu"

describe ZabbixRubyClient::Plugins::Cpu do

  before :all do
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "launches a command to get stats" do
    expect(ZabbixRubyClient::Plugins::Cpu).to receive(:`).with('cat /proc/stat | grep "^cpu"')
    ZabbixRubyClient::Plugins::Cpu.send(:cpuinfo)
  end

  it "prepare data to be usable" do
    expected = [0, 22435289, 82535, 7282312, 202052034, 2585403, 439, 117194, 0, 0, 0, 29800136, 0]
    stubfile = File.expand_path('../../../../spec/files/system/proc_cpu', __FILE__)
    ZabbixRubyClient::Plugins::Cpu.stub(:cpuinfo).and_return(File.read(stubfile))
    data = ZabbixRubyClient::Plugins::Cpu.send(:get_info)
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local cpu[user] 123456789 22435289", 
      "local cpu[nice] 123456789 82535", 
      "local cpu[system] 123456789 7282312", 
      "local cpu[iowait] 123456789 202052034", 
      "local cpu[irq] 123456789 2585403", 
      "local cpu[soft] 123456789 439", 
      "local cpu[steal] 123456789 117194", 
      "local cpu[guest] 123456789 0", 
      "local cpu[idle] 123456789 0", 
      "local cpu[used] 123456789 0", 
      "local cpu[total] 123456789 29800136"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/proc_cpu', __FILE__)
    ZabbixRubyClient::Plugins::Cpu.stub(:cpuinfo).and_return(File.read(stubfile))
    Time.stub(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Cpu.send(:collect, 'local')
    expect(data).to eq expected
  end

end
