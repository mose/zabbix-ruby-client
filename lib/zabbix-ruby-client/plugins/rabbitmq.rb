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
          back << "#{host} rabbitmq.erlang.version #{time} #{info['erlang_version']}"
          back << "#{host} rabbitmq.message.ack #{time} #{info['message_stats']['ack']}"
          back << "#{host} rabbitmq.message.ack.rate #{time} #{info['message_stats']['ack_details']['rate']}"
          back << "#{host} rabbitmq.message.deliver #{time} #{info['message_stats']['deliver']}"
          back << "#{host} rabbitmq.message.deliver.rate #{time} #{info['message_stats']['deliver_details']['rate']}"
          back << "#{host} rabbitmq.message.deliver_get #{time} #{info['message_stats']['deliver_get']}"
          back << "#{host} rabbitmq.message.deliver_get.rate #{time} #{info['message_stats']['deliver_get_details']['rate']}"
          back << "#{host} rabbitmq.message.deliver_get #{time} #{info['message_stats']['deliver_get']}"
          back << "#{host} rabbitmq.message.deliver_get.rate #{time} #{info['message_stats']['deliver_get_details']['rate']}"
          back << "#{host} rabbitmq.message.publish #{time} #{info['message_stats']['publish']}"
          back << "#{host} rabbitmq.message.publish.rate #{time} #{info['message_stats']['publish_details']['rate']}"
          back << "#{host} rabbitmq.message.redeliver #{time} #{info['message_stats']['redeliver']}"
          back << "#{host} rabbitmq.message.redeliver.rate #{time} #{info['message_stats']['redeliver_details']['rate']}"
          back << "#{host} rabbitmq.queue.total.messages #{time} #{info['queue_totals']['messages']}"
          back << "#{host} rabbitmq.queue.total.messages_ready #{time} #{info['queue_totals']['messages_ready']}"
          back << "#{host} rabbitmq.queue.total.messages_unacknowledged #{time} #{info['queue_totals']['messages_unacknowledged']}"
          back << "#{host} rabbitmq.total.channels #{time} #{info['object_totals']['channels']}"
          back << "#{host} rabbitmq.total.connections #{time} #{info['object_totals']['connections']}"
          back << "#{host} rabbitmq.total.consumers #{time} #{info['object_totals']['consumers']}"
          back << "#{host} rabbitmq.total.exchanges #{time} #{info['object_totals']['exchanges']}"
          back << "#{host} rabbitmq.total.listeners #{time} #{info['listeners'].count}"
          back << "#{host} rabbitmq.total.queues #{time} #{info['object_totals']['queues']}"
          back << "#{host} rabbitmq.version #{time} #{info['rabbitmq_version']}"
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
