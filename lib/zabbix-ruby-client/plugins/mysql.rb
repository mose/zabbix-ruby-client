class ZabbixRubyClient
  module Plugins
    module Mysql
      extend self

      def collect(*args)
        host = args[0]
        mysqlargs = args[1]
        mysqlstatus = `mysqladmin #{mysqlargs} extended-status`
        if $?.to_i == 0
          status = get_status(mysqlstatus)
        else
          self.logger.warn "The connection failed."
          return []
        end

        time = Time.now.to_i
        back = []
        back << "#{host} mysql.status[Aborted_clients] #{time} #{status["Aborted_clients"]}"
        back << "#{host} mysql.status[Aborted_connects] #{time} #{status["Aborted_connects"]}"
        back << "#{host} mysql.status[Bytes_received] #{time} #{status["Bytes_received"]}"
        back << "#{host} mysql.status[Bytes_sent] #{time} #{status["Bytes_sent"]}"
        back << "#{host} mysql.status[Com_admin_commands] #{time} #{status["Com_admin_commands"]}"
        back << "#{host} mysql.status[Com_begin] #{time} #{status["Com_begin"]}"
        back << "#{host} mysql.status[Com_change_db] #{time} #{status["Com_change_db"]}"
        back << "#{host} mysql.status[Com_check] #{time} #{status["Com_check"]}"
        back << "#{host} mysql.status[Com_commit] #{time} #{status["Com_commit"]}"
        back << "#{host} mysql.status[Com_delete] #{time} #{status["Com_delete"]}"
        back << "#{host} mysql.status[Com_insert] #{time} #{status["Com_insert"]}"
        back << "#{host} mysql.status[Com_rollback] #{time} #{status["Com_rollback"]}"
        back << "#{host} mysql.status[Com_lock_tables] #{time} #{status["Com_lock_tables"]}"
        back << "#{host} mysql.status[Com_select] #{time} #{status["Com_select"]}"
        back << "#{host} mysql.status[Com_show_fields] #{time} #{status["Com_show_fields"]}"
        back << "#{host} mysql.status[Com_unlock_tables] #{time} #{status["Com_unlock_tables"]}"
        back << "#{host} mysql.status[Com_update] #{time} #{status["Com_update"]}"
        back << "#{host} mysql.status[Connections] #{time} #{status["Connections"]}"
        back << "#{host} mysql.status[Created_tmp_disk_tables] #{time} #{status["Created_tmp_disk_tables"]}"
        back << "#{host} mysql.status[Created_tmp_tables] #{time} #{status["Created_tmp_tables"]}"
        back << "#{host} mysql.status[Slave_running] #{time} #{status["Slave_running"]}"
        back << "#{host} mysql.status[Slow_queries] #{time} #{status["Slow_queries"]}"
        back << "#{host} mysql.status[Uptime] #{time} #{status["Uptime"]}"
        back << "#{host} mysql.status[Questions] #{time} #{status["Questions"]}"
        return back
      end


      def get_status(status)
        ret = {}
        status.each_line do |l|
          if l[0] == "|"
            _, k, v = l.split "|"
            ret[k.strip] = v.strip
          end
        end
        ret
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('mysql', ZabbixRubyClient::Plugins::Mysql)

