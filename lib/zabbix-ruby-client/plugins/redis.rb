# this is a simple version for standalone redis server
require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Redis
      extend self

      def collect(*args)
        host = args[0]
        redis = args[1] || 'redis-cli'
        opts = args[2] || ""
        redisinfo = `#{redis} #{opts} info`
        if $?.to_i == 0
          info = get_info(redisinfo)
        else
          Log.warn "Redis connection failed."
          return []
        end

        info[:keyspace_total] = info[:keyspace_hits].to_i + info[:keyspace_misses].to_i

        time = Time.now.to_i
        back = []
        back << "#{host} redis[role] #{time} #{info[:role]}"
        back << "#{host} redis[version] #{time} #{info[:redis_version]}"
        back << "#{host} redis[used_memory] #{time} #{info[:used_memory]}"
        back << "#{host} redis[connections] #{time} #{info[:total_connections_received]}"
        back << "#{host} redis[commands] #{time} #{info[:total_commands_processed]}"
        back << "#{host} redis[hits] #{time} #{info[:keyspace_hits]}"
        back << "#{host} redis[misses] #{time} #{info[:keyspace_misses]}"
        back << "#{host} redis[total] #{time} #{info[:keyspace_total]}"
        back << "#{host} redis[changes_since_last_save] #{time} #{info[:rdb_changes_since_last_save]}"
        return back
      end

      def get_info(meat)
        ret = {}
        meat.each_line do |line|
          if line.size > 0 && line[0] != '#'
            key, value = line.split(/\:/)
            ret[key.to_sym] = value
          end
        end
        ret
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('redis', ZabbixRubyClient::Plugins::Redis)
