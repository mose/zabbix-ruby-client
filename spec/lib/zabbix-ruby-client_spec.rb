# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client"

describe ZabbixRubyClient do

  before :each do
    @basedir = File.expand_path("../../files", __FILE__)
    Dir.chdir @basedir
    @config_file = File.join(@basedir, "config.yml")
    @task_file = File.join(@basedir, "task.yml")
  end

  after :each do
    logfile = File.join("logs","zrc.log")
    File.unlink(logfile) if File.exists?(logfile)
  end

  it "initialize the client object" do
    @zrc = ZabbixRubyClient.new(@config_file, @task_file)
    expect(@zrc.instance_variable_get(:@config)['host']).to eq 'localhost'
  end

  it "creates dirs if needed" do
    FileUtils.mv("logs","logsback")
    @zrc = ZabbixRubyClient.new(@config_file, @task_file)
    expect(Dir.exists? "logs").to be_true
  end

  pending "loads list of plugins"
  pending "initialize datafile according to config"
  pending "stores data in datafile"
  pending "runs list of plugins according to config"
  pending "issues the upload command according to config"

end
