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
    stubfile = File.expand_path('../../../../spec/files/system/proc_cpu', __FILE__)
    puts File.read(stubfile)
    ZabbixRubyClient::Plugins::Cpu.stub(:cpuinfo).and_return(File.read(stubfile))
    data = ZabbixRubyClient::Plugins::Cpu.send(:get_info)
    expect(data).to eq ''
  end

  it "populate a hash with extracted data" do
    expected = ''
    stubfile = File.expand_path('../../../../spec/files/system/proc_cpu', __FILE__)
    ZabbixRubyClient::Plugins::Cpu.stub(:cpuinfo).and_return(File.read(stubfile))
    Time.stub(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Cpu.send(:collect, 'local')
    expect(data).to eq expected
  end

end
