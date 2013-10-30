# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client"

describe ZabbixRubyClient::Runner do

  before :each do
    @basedir = File.expand_path("../../files", __FILE__)
    Dir.chdir @basedir
    config_file = File.join(@basedir, "config.yml")
    @config = YAML::load_file(config_file)
    task_file = File.join(@basedir, "task.yml")
    @tasks = YAML::load_file(task_file)
  end

  after :each do
    logfile = File.join("logs", "zrc.log")
    File.unlink(logfile) if File.exists?(logfile)
  end

  it "initialize the client object" do
    @zrc = ZabbixRubyClient::Runner.new(@config, @tasks)
    expect(@zrc.instance_variable_get(:@config)['host']).to eq 'localhost'
  end

  it "creates dirs if needed" do
    @zrc = ZabbixRubyClient::Runner.new(@config, @tasks)
    expect(Dir.exists? "logs").to be_true
  end

  pending "loads list of plugins"
  pending "initialize datafile according to config"
  pending "stores data in datafile"
  pending "issues the upload command according to config"

end
