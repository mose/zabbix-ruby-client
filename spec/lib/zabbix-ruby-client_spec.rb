# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client"

describe ZabbixRubyClient do

  before :all do
    basedir = File.expand_path("../../files", __FILE__)
    @config_file = File.join(basedir, "config.yml")
    @task_file = File.join(basedir, "task.yml")
  end

  it "initialize the client object" do
    @zrc = ZabbixRubyClient.new(@config_file, @task_file)
    expect(@zrc.instance_variable_get(:@config)['host']).to eq 'localhost'
    expect(@zrc.instance_variable_get(:@config)['host']).to eq 'localhost'
  end

  pending "creates dirs if needed"
  pending "loads list of plugins"
  pending "initialize datafile according to config"
  pending "stores data in datafile"
  pending "runs list of plugins according to config"
  pending "issues the upload command according to config"

end
