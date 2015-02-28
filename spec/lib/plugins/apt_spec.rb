# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugin_base"
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/apt"

describe ZabbixRubyClient::Plugins::Apt do

  before :all do
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "launches a command to get apt stats" do
    expect(ZabbixRubyClient::Plugins::Apt).to receive(:`).with('/usr/lib/update-notifier/apt-check 2>&1')
    ZabbixRubyClient::Plugins::Apt.send(:aptinfo)
  end

  it "prepare data to be usable" do
    expected = [23, 14]
    stubfile = File.expand_path('../../../../spec/files/system/apt-check', __FILE__)
    allow(ZabbixRubyClient::Plugins::Apt).to receive(:aptinfo).and_return(File.read(stubfile))
    data = ZabbixRubyClient::Plugins::Apt.send(:get_info)
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local apt[security] 123456789 23",
      "local apt[pending] 123456789 14",
      "local apt[status] 123456789 TODO apt 23/14"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/apt-check', __FILE__)
    allow(ZabbixRubyClient::Plugins::Apt).to receive(:aptinfo).and_return(File.read(stubfile))
    allow(Time).to receive(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Apt.send(:collect, 'local')
    expect(data).to eq expected
  end

end
