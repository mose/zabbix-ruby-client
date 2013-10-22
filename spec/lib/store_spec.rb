# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/store"

describe ZabbixRubyClient::Store do

  before :all do
    @datadir = File.expand_path("../../files/data", __FILE__)
    @data = [ "1", "2" ]
    @file = File.join(@datadir,"test")
  end

  before :each do
    @store = ZabbixRubyClient::Store.new(@datadir, "server", "task")
  end

  after :each do
    File.unlink(@file) if File.exists?(@file)
    File.unlink(@store.pendingfile) if File.exists?(@store.pendingfile)
  end

  describe "write method" do

    it ".write really writes a file" do
      @store.write(@data,@file)
      expect(File.exists?(@file)).to be true
    end

    it ".write record the data" do
      file = File.join(@datadir,"test")
      @store.write(@data,@file)
      expect(File.read(@file)).to eq "1\n2\n"
    end

    it ".write record the data prepended if any" do
      file = File.join(@datadir,"test")
      @store.write(@data,@file, "something\n")
      expect(File.read(@file)).to eq "something\n1\n2\n"
    end

    it ".write returns the name of the file" do
      file = File.join(@datadir,"test")
      expect(@store.write(@data,@file)).to eq @file
    end

  end

  it "knows about pendingfile" do
    expect(@store.pendingfile).to eq File.join(@datadir, "server-pending")
  end

  it "find no pending content if pending file is not here" do
    expect(@store.pending_content).to eq ""
  end

  it "finds a pending content if there is a file" do
    File.write(@store.pendingfile,"ha\n")
    expect(@store.pending_content).to eq "ha\n"
  end

  it "erase the pendingfile if found" do
    File.write(@store.pendingfile,"ha\n")
    @store.pending_content
    expect(File.exists?(@store.pendingfile)).to be false
  end

  it "keepdata moves the datafile" do
    File.write(@file,"ha\n")
    @store.keepdata(@file)
    expect(File.exists?(@store.pendingfile)).to be true
    expect(File.exists?(@file)).to be false
  end

  it "records data using the write method" do
    expect(@store).to receive(:write).with(@data, @store.datafile, @store.pending_content)
    @store.record(@data)
  end

end