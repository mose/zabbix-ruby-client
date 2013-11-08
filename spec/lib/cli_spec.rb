# encoding: utf-8

require 'spec_helper'
require "zabbix-ruby-client/cli"

describe ZabbixRubyClient::Cli do
  
  before :each do
    @cli = ZabbixRubyClient::Cli.new(
      [], 
      { 
        'configfile' => 'config.yml', 
        'taskfile' => 'minutely.yml' 
      }
    )
    @testdir = File.join('spec','files','test-client')
    @cli.shell.mute do
      @cli.init(@testdir)
    end
    @oldpwd = Dir.pwd
    Dir.chdir @testdir 
  end

  after :each do
    Dir.chdir @oldpwd
    FileUtils.rm_rf @testdir if Dir.exists? @testdir
  end

  it "init creates a working directory" do
    expect(File.file? 'Gemfile').to be_true
  end

  it "show displays the list of data collected" do
    ZabbixRubyClient::Runner.stub(:new).and_return(Object)
    Object.stub(:collect)
    Object.stub(:show)
    @cli.shell.mute do
      @cli.show
    end
  end

  it "upload collects and uploads the data from system" do
    ZabbixRubyClient::Runner.stub(:new).and_return(Object)
    Object.stub(:collect)
    Object.stub(:upload)
    @cli.shell.mute do
      @cli.upload
    end
  end

end