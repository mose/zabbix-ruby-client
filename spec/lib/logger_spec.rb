# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/logger"

describe ZabbixRubyClient::Log do

  before :all do
    @logfile = File.expand_path("../../files/logs/testlog", __FILE__)
  end

  after :each do
    File.unlink(@logfile) if File.exists?(@logfile)
  end

  it "set_logger prepares the logger" do
    ZabbixRubyClient::Log.set_logger(@logfile, 'info')
    expect(ZabbixRubyClient::Log.instance_variable_get(:@logger)).to be_instance_of Logger
    expect(ZabbixRubyClient::Log.logger.level).to be Logger::INFO
  end

  it "logged message are nicely formatted" do
    ZabbixRubyClient::Log.set_logger(@logfile, 'debug')
    ZabbixRubyClient::Log.logger.debug("ha")
    expect(File.read(@logfile)).to match /\] DEBUG: ha\n/
  end

  it "loglevel is properly interpreted from argument" do
    ZabbixRubyClient::Log.set_logger(@logfile, 'debug')
    expect(ZabbixRubyClient::Log.instance_variable_get(:@logger).level).to be Logger::DEBUG
  end

end
