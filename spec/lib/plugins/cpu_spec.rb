# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugin_base"
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

  it "prepare data to be usable" do
    expected = {
      "user" => 473806,
      "nice" => 20486,
      "system" => 406619,
      "idle" => 187353904,
      "iowait" => 11589,
      "irq" => 9,
      "soft" => 696,
      "steal" => 5186311,
      "guest" => 0,
      "used" => 900911,
      "total" => 193453420
    }
    stubfile = File.expand_path('../../../../spec/files/system/proc_cpu', __FILE__)
    ZabbixRubyClient::Plugins::Cpu.stub(:getline).and_return(File.read(stubfile))
    data = ZabbixRubyClient::Plugins::Cpu.send(:get_info)
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local cpu[user] 123456789 473806",
      "local cpu[nice] 123456789 20486",
      "local cpu[system] 123456789 406619",
      "local cpu[idle] 123456789 187353904",
      "local cpu[iowait] 123456789 11589",
      "local cpu[irq] 123456789 9",
      "local cpu[soft] 123456789 696",
      "local cpu[steal] 123456789 5186311",
      "local cpu[guest] 123456789 0",
      "local cpu[used] 123456789 900911",
      "local cpu[total] 123456789 193453420"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/proc_cpu', __FILE__)
    ZabbixRubyClient::Plugins::Cpu.stub(:getline).and_return(File.read(stubfile))
    Time.stub(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Cpu.send(:collect, 'local')
    expect(data).to eq expected
  end

end
