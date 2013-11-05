# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/plugins"

describe ZabbixRubyClient::Plugins do

  before :all do
    @plugindir = File.expand_path("../../files/plugins", __FILE__)
  end

  before :each do
    ZabbixRubyClient::Plugins.scan_dirs([@plugindir])
  end

  after :each do
    ZabbixRubyClient::Plugins.reset
  end

  it "loading dirs works" do
    result = { "sample" => File.join(@plugindir, "sample.rb"),
               "sample_discover" => File.join(@plugindir, "sample_discover.rb")}
    expect(ZabbixRubyClient::Plugins.instance_variable_get(:@available)).to eq result 
  end

  it "registering a new plugin loads it" do
    ZabbixRubyClient::Plugins.register("sample",Object)
    result = { "sample" => Object }
    expect(ZabbixRubyClient::Plugins.instance_variable_get(:@loaded)).to eq result
  end

  it "loading a plugin adds plugin in loaded list" do
    ZabbixRubyClient::Plugins.load("sample")
    expect(Sample).to be_kind_of Module
  end

  it "do not load a plugin already loaded" do
    ZabbixRubyClient::Plugins.load("sample")
    ZabbixRubyClient::Plugins.load("sample")
    result = { "sample" => Sample }
    expect(ZabbixRubyClient::Plugins.instance_variable_get(:@loaded)).to eq result
  end

end
