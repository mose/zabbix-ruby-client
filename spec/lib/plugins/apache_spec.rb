# encoding: utf-8

require 'spec_helper'
require 'webmock/rspec'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/apache"

describe ZabbixRubyClient::Plugins::Apache do

  before :each do
    stubfile = File.expand_path('../../../../spec/files/system/apache_status', __FILE__)
    @data = File.read(stubfile)
    @processed = {
      "Total Accesses"=>"12",
      "Total kBytes"=>"6",
      "CPULoad"=>"5.69795e-5",
      "Uptime"=>"1175861",
      "ReqPerSec"=>"4.16716e-5",
      "BytesPerSec"=>"1.0128",
      "BytesPerReq"=>"24304.3",
      "BusyWorkers"=>"1",
      "IdleWorkers"=>"4",
      "Scoreboard"=>"__S__W__W_........"}
    @expected_data = [
      "local apache[TotalAccesses] 123456789 12",
      "local apache[TotalKBytes] 123456789 6",
      "local apache[CPULoad] 123456789 5.69795e-05",
      "local apache[Uptime] 123456789 1175861",
      "local apache[ReqPerSec] 123456789 4.16716e-05",
      "local apache[BytesPerSec] 123456789 1.0128",
      "local apache[BytesPerReq] 123456789 24304.3",
      "local apache[BusyWorkers] 123456789 1",
      "local apache[IdleWorkers] 123456789 4",
      "local apache[c_idle] 123456789 8",
      "local apache[c_waiting] 123456789 7",
      "local apache[c_closing] 123456789 0",
      "local apache[c_dns] 123456789 0",
      "local apache[c_finish] 123456789 0",
      "local apache[c_cleanup] 123456789 0",
      "local apache[c_keep] 123456789 0",
      "local apache[c_log] 123456789 0",
      "local apache[c_read] 123456789 0",
      "local apache[c_send] 123456789 2",
      "local apache[c_start] 123456789 1"
    ]
  end

  it "gets the status page from localhost" do
    stub_request(:get, '127.0.0.1:80/server-status?auto')
    ZabbixRubyClient::Plugins::Apache.send(:get_status)
  end

  it "populate a hash with extracted data" do
    stub_request(:get, '127.0.0.1:80/server-status?auto').
      to_return({ :body => @data })
    status = ZabbixRubyClient::Plugins::Apache.send(:get_status)
    expect(status).to eq @processed
  end

  it "populate scores from scoreboard data" do
    expected = {
      "_" => 7,
      "S" => 1,
      "R" => 0,
      "W" => 2,
      "K" => 0,
      "D" => 0,
      "C" => 0,
      "L" => 0,
      "G" => 0,
      "I" => 0,
      "." => 8
    }
    board = ZabbixRubyClient::Plugins::Apache.send(:get_scores, @processed['Scoreboard'])
    expect(board).to eq expected
  end

  it "collects data properly" do
    stub_request(:get, '127.0.0.1:80/server-status?auto').
      to_return({ :body => @data })
    Time.stub(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Apache.send(:collect, 'local')
    expect(data).to eq @expected_data
  end

end
