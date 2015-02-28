# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugin_base"
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/disk"

describe ZabbixRubyClient::Plugins::Disk do

  before :all do
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "launches a command to get disk space" do
    expect(ZabbixRubyClient::Plugins::Disk).to receive(:`).with('df | grep "xx"')
    ZabbixRubyClient::Plugins::Disk.send(:diskinfo, 'xx')
  end

  it "prepare data to be usable" do
    expected = [
      "/dev/sda2",
      "288238944",
      "76560212",
      "197013928",
      "28%",
      "/home",
      "",
      "8",
      "1",
      "sda1",
      "974243",
      "695335",
      "37526290",
      "4648644",
      "711455",
      "785503",
      "27660904",
      "11097172",
      "0",
      "6283844",
      "15744924"
    ]
    stubfile_df = File.expand_path('../../../../spec/files/system/df', __FILE__)
    stubfile_io = File.expand_path('../../../../spec/files/system/diskstats', __FILE__)
    allow(ZabbixRubyClient::Plugins::Disk).to receive(:diskinfo).and_return(File.read(stubfile_df))
    allow(ZabbixRubyClient::Plugins::Disk).to receive(:getline).and_return(File.read(stubfile_io))
    data = ZabbixRubyClient::Plugins::Disk.send(:get_info, 0, 0)
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local disk.space[xxx,size] 123456789 288238944000",
      "local disk.space[xxx,used] 123456789 76560212000",
      "local disk.space[xxx,available] 123456789 197013928000",
      "local disk.space[xxx,percent_used] 123456789 28",
      "local disk.io[xxx,read_ok] 123456789 sda1",
      "local disk.io[xxx,read_merged] 123456789 974243",
      "local disk.io[xxx,read_sector] 123456789 695335",
      "local disk.io[xxx,read_time] 123456789 37526290",
      "local disk.io[xxx,write_ok] 123456789 4648644",
      "local disk.io[xxx,write_merged] 123456789 711455",
      "local disk.io[xxx,write_sector] 123456789 785503",
      "local disk.io[xxx,write_time] 123456789 27660904",
      "local disk.io[xxx,io_time] 123456789 11097172",
      "local disk.io[xxx,io_weighted] 123456789 0"
    ]
    stubfile_df = File.expand_path('../../../../spec/files/system/df', __FILE__)
    stubfile_io = File.expand_path('../../../../spec/files/system/diskstats', __FILE__)
    allow(ZabbixRubyClient::Plugins::Disk).to receive(:diskinfo).and_return(File.read(stubfile_df))
    allow(ZabbixRubyClient::Plugins::Disk).to receive(:getline).and_return(File.read(stubfile_io))
    allow(Time).to receive(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Disk.send(:collect, 'local', 'xxx', 'xxx')
    expect(data).to eq expected
  end

  it "declares discoverable volumes" do
    expected = [ "disk.dev.discovery", '{"{#DISK_DEVICE}": "sda1", "{#DISK_MOUNT}": "lvm1"}' ]
    data = ZabbixRubyClient::Plugins::Disk.send(:discover, '', 'lvm1', 'sda1')
    expect(data).to eq expected
  end

end
