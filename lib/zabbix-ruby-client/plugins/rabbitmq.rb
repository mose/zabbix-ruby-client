# read the remote data from http://mq-dev.faria.co/
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"
require "json"
require "net/http"
require "curb"

module ZabbixRubyClient
  module Plugins
    module Rabbitmq
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        url = "http://host/api/overview"
        username = "user"
        userpwd = "pass"
        info = get_info(url,username,userpwd)
        back = []
        if info
          time = Time.now.to_i
          back << "#{host} rabbitmq[received] #{time} #{info['publish']}"
          back << "#{host} rabbitmq[sent] #{time} #{info['ack']}"
          back << "#{host} rabbitmq[count] #{time} #{info['deliver_get']}"
          back << "#{host} rabbitmq[count] #{time} #{info['redeliver']}"
          back << "#{host} rabbitmq[count] #{time} #{info['deliver']}"
          back << "#{host} rabbitmq[count] #{time} #{info['messages']}"
          back << "#{host} rabbitmq[count] #{time} #{info['messages_ready']}"
          back << "#{host} rabbitmq[count] #{time} #{info['messages_unacknowledged']}"
          back << "#{host} rabbitmq[count] #{time} #{info['consumers']}"
          back << "#{host} rabbitmq[count] #{time} #{info['queues']}"
          back << "#{host} rabbitmq[count] #{time} #{info['exchanges']}"
          back << "#{host} rabbitmq[count] #{time} #{info['connections']}"
          back << "#{host} rabbitmq[count] #{time} #{info['channels']}"
        end
        back
      end

    private

      def get_info(url,username,userpwd)

        curl = Curl::Easy.new(url)
        curl.username = username
        curl.password = userpwd
        curl.perform
        data_obj = JSON.parse(curl.body_str)

        ret = {}
        data_obj["message_stats"].each do |dshow|
          ret[dshow[0]]=dshow[1]
        end
        data_obj["queue_totals"].each do |qshow|
          ret[qshow[0]]=qshow[1]
        end
        data_obj["object_totals"].each do |oshow|
          ret[oshow[0]]=oshow[1]
        end

        # puts ret["publish"]
        # puts ret["ack"]
        # puts ret["deliver_get"]
        # puts ret["redeliver"]
        # puts ret["deliver"]
        # puts ret["messages"]
        # puts ret["messages_ready"]
        # puts ret["messages_unacknowledged"]
        # puts ret["consumers"]
        # puts ret["queues"]
        # puts ret["exchanges"]
        # puts ret["connections"]
        # puts ret["channels"]

        ret
#        info = getlines(data_obj, "[^,]*,[^,]*,.* [0-9]{4}")
#        if info
#          received = 0
#          sent = 0
#          count = 0
#          info.each do |line|
#            if line[0] =~ /^[a-z]/
#              back = line.split(',')
#              received += back[2].to_i
#              sent += back[3].to_i
#              count += 1
            # end
          # end
          # ret["received"] = received
          # ret["sent"] = sent
          # ret["count"] = count
          # ret
        # else
          # false
        # end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('rabbitmq', ZabbixRubyClient::Plugins::Rabbitmq)
