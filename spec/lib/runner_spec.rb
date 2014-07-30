# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client"

describe ZabbixRubyClient::Runner do

  let(:config) { {
    'datadir' => 'data',
    'logsdir' => 'logs',
    'plugindirs' => [ 'plugins' ],
    'keepdata' => false,
    'host' => 'localhost',
    'taskfile' => nil,
    'zabbix' => {
      'host' => 'localhost',
      'sender' => '/bin/true'
    }
  } }
  let(:tasks) { {
    'name' => 'sysinfo'
  } }

  before :each do
    @basedir = File.expand_path("../../files", __FILE__)
    Dir.chdir @basedir
  end

  after :each do
    logfile = File.join(config['logsdir'], "zrc.log")
    File.unlink(logfile) if File.exists?(logfile)
    FileUtils.rmdir(config['logsdir']) if Dir.exists?(config['logsdir'])
  end

  it "initialize the client object" do
    @zrc = ZabbixRubyClient::Runner.new(config, tasks)
    expect(@zrc.instance_variable_get(:@config)['host']).to eq 'localhost'
  end

  it "creates dirs if needed" do
    @zrc = ZabbixRubyClient::Runner.new(config, tasks)
    expect(Dir.exists? "logs").to be_truthy
  end

  pending "loads list of plugins"
  pending "initialize datafile according to config"
  pending "stores data in datafile"
  pending "issues the upload command according to config"

end
