# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"
ZabbixRubyClient::Plugins.scan_dirs ["zabbix-ruby-client/plugins"]
require "zabbix-ruby-client/plugins/memory"

describe ZabbixRubyClient::Plugins::Memory do
  

  before :all do
    @logfile = File.expand_path("../../files/logs/spec.log", __FILE__)
    ZabbixRubyClient::Log.set_logger(@logfile)
  end

  after :all do
    FileUtils.rm_rf @logfile if File.exists? @logfile
  end

  it "launches a command to get meminfo" do
    expect(ZabbixRubyClient::Plugins::Memory).to receive(:`).with('cat /proc/meminfo')
    ZabbixRubyClient::Plugins::Memory.send(:meminfo)
  end

  it "prepare data to be usable" do
    expected = {
      "MemTotal"=>4229570560, 
      "MemFree"=>685416448, 
      "Buffers"=>59116, 
      "Cached"=>385776, 
      "SwapCached"=>204968, 
      "Active"=>2664148, 
      "Inactive"=>883200, 
      "Unevictable"=>212, 
      "Mlocked"=>212, 
      "HighTotal"=>3280520, 
      "HighFree"=>41136, 
      "LowTotal"=>849920, 
      "LowFree"=>183324, 
      "SwapTotal"=>5999050752, 
      "SwapFree"=>3666022400, 
      "Dirty"=>532, 
      "Writeback"=>0, 
      "AnonPages"=>3002480, 
      "Mapped"=>278560, 
      "Shmem"=>110636, 
      "Slab"=>92716, 
      "SReclaimable"=>60300, 
      "SUnreclaim"=>32416, 
      "KernelStack"=>7752, 
      "PageTables"=>49584, 
      "NFS_Unstable"=>0, 
      "Bounce"=>0, 
      "WritebackTmp"=>0, 
      "CommitLimit"=>7923668, 
      "Committed_AS"=>15878488, 
      "VmallocTotal"=>122880, 
      "VmallocUsed"=>49400, 
      "VmallocChunk"=>66212, 
      "HardwareCorrupted"=>0, 
      "AnonHugePages"=>0, 
      "Hugepagesize"=>2048, 
      "DirectMap4k"=>851960, 
      "DirectMap2M"=>61440, 
      "MemUsed"=>3544154112, 
      "MemPercent"=>83, 
      "SwapUsed"=>2333028352, 
      "SwapPercent"=>38
    }
    stubfile = File.expand_path('../../../../spec/files/system/meminfo', __FILE__)
    ZabbixRubyClient::Plugins::Memory.stub(:meminfo).and_return(File.read(stubfile))
    data = ZabbixRubyClient::Plugins::Memory.send(:get_info)
    expect(data).to eq expected
  end

  it "populate a hash with extracted data" do
    expected = [
      "local memory[total] 123456789 4229570560", 
      "local memory[free] 123456789 685416448",
      "local memory[used] 123456789 3544154112", 
      "local memory[percent_used] 123456789 83", 
      "local memory[swap_total] 123456789 5999050752", 
      "local memory[swap_free] 123456789 3666022400", 
      "local memory[swap_used] 123456789 2333028352", 
      "local memory[swap_percent_used] 123456789 38"
    ]
    stubfile = File.expand_path('../../../../spec/files/system/meminfo', __FILE__)
    ZabbixRubyClient::Plugins::Memory.stub(:meminfo).and_return(File.read(stubfile))
    Time.stub(:now).and_return("123456789")
    data = ZabbixRubyClient::Plugins::Memory.send(:collect, 'local')
    expect(data).to eq expected
  end

end