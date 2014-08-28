# read the remote data with http://www.rabbitmq.com/management-cli.html
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"
require "json"

module ZabbixRubyClient
  module Plugins
    module Rabbitmq
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        rabbitmqadmin = args[1]
        login = args[2]
        pass = args[3]
        info = get_info(rabbitmqadmin, login, pass)
        back = []
        if info
          time = Time.now.to_i
          back << "#{host} rabbitmq.version #{time} #{info['rabbitmq_version']}"
          back << "#{host} rabbitmq.erlang.version #{time} #{info['erlang_version']}"
          %w(ack deliver deliver_get publish redeliver).each do |i|
            back << "#{host} rabbitmq.message.#{i} #{time} #{info['message_stats'][i]}"
            back << "#{host} rabbitmq.message.#{i}.rate #{time} #{info['message_stats']["#{i}_details"]['rate'].round}"
          end
          %w(messages messages_ready messages_unacknowledged).each do |i|
            back << "#{host} rabbitmq.queue.total.#{i} #{time} #{info['queue_totals'][i]}"
          end
          %w(channels connections consumers exchanges queues).each do |i|
            back << "#{host} rabbitmq.total.#{i} #{time} #{info['object_totals'][i]}"
          end
          back << "#{host} rabbitmq.total.listeners #{time} #{info['listeners'].count}"
        end
        back
      end

    private

      def get_info(rabbitmqadmin, login, pass)
        command = "#{rabbitmqadmin} -u #{login} -p #{pass} -f raw_json show overview"
        Log.debug command
        JSON.parse(`#{command}`).first
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('rabbitmq', ZabbixRubyClient::Plugins::Rabbitmq)
