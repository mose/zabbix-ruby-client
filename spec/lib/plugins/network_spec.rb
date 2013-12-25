# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/network"

describe ZabbixRubyClient::Plugins::Network do
  

  before :all do
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "prepare data to be usable" do
    expected = [
      "eth0:", 
      "8523363858", 
      "17554648", 
      "0", 
      "0", 
      "0", 
      "0", 
      "0", 
      "589997", 
      "2479556217", 
      "15780062", 
      "0", 
      "0", 
      "0", 
      "0", 
      "0", 
      "0"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/net_dev', __FILE__)
    ZabbixRubyClient::Plugins::Network.stub(:getline).and_return(File.read(stubfile))
    data = ZabbixRubyClient::Plugins::Network.send(:get_info, 'eth0')
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local net.rx_ok[eth0] 123456789 8523363858", 
      "local net.rx_packets[eth0] 123456789 17554648", 
      "local net.rx_err[eth0] 123456789 0", 
      "local net.rx_drop[eth0] 123456789 0", 
      "local net.tx_ok[eth0] 123456789 2479556217", 
      "local net.tx_packets[eth0] 123456789 15780062", 
      "local net.tx_err[eth0] 123456789 0", 
      "local net.tx_drop[eth0] 123456789 0"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/net_dev', __FILE__)
    ZabbixRubyClient::Plugins::Network.stub(:getline).and_return(File.read(stubfile))
    Time.stub(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Network.send(:collect, 'local', 'eth0')
    expect(data).to eq expected
  end

  it "declares discoverable interfaces" do
    expected = [ "net.if.discovery", '{"{#NET_IF}": "eth0"}' ]
    data = ZabbixRubyClient::Plugins::Network.send(:discover, 'eth0')
    expect(data).to eq expected
  end

end
