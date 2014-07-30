# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/load"

describe ZabbixRubyClient::Plugins::Load do

  before :all do
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "prepare data to be usable" do
    expected = ["0.89", "1.29", "1.05", "2", "2768"]
    stubfile = File.expand_path('../../../../spec/files/system/loadavg', __FILE__)
    allow(ZabbixRubyClient::Plugins::Load).to receive(:getline).and_return(File.read(stubfile).strip)
    data = ZabbixRubyClient::Plugins::Load.send(:get_info)
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local load[one] 123456789 0.89",
      "local load[five] 123456789 1.29",
      "local load[fifteen] 123456789 1.05",
      "local load[procs] 123456789 2"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/loadavg', __FILE__)
    allow(ZabbixRubyClient::Plugins::Load).to receive(:getline).and_return(File.read(stubfile))
    allow(Time).to receive(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Load.send(:collect, 'local')
    expect(data).to eq expected
  end

end
