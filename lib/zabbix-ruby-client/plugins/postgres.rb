require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Postgres
      extend self

      def collect(*args)
        host = args[0]
        psqlargs = args[1]
        dbname = args[2]
        # be sure to have this in the config file
        # args: [ "-U username -h localhost", "dbname" ]
        # and setup username in a ~/.pgpass (0600) file for the zrc user
        # localhost:5432:dbname:username:password
        psqlstatus = `psql #{psqlargs} -A -t -c "select * from pg_stat_database where datname='#{dbname}'" #{dbname}`
        if $?.to_i == 0
          status = get_status(psqlstatus)
        else
          Log.warn "The connection failed."
          return []
        end
        psqlactivity = `psql #{psqlargs} -A -t -c "select state, count(*) from pg_stat_activity group by state" #{dbname}`
        if $?.to_i == 0
          activity = get_activity(psqlactivity)
        else
          Log.warn "The connection failed."
          return []
        end
        psqlwriter = `psql #{psqlargs} -A -t -c "select * from pg_stat_bgwriter" #{dbname}`
        if $?.to_i == 0
          writer = get_writer(psqlwriter)
        else
          Log.warn "The connection failed."
          return []
        end

        time = Time.now.to_i
        back = []
        status.each do |e,v|
          back << "#{host} postgres.#{e}[#{dbname}] #{time} #{v}"
        end
        activity.each do |e,v|
          back << "#{host} postgres.connections.#{e} #{time} #{v}"
        end
        writer.each do |e,v|
          back << "#{host} postgres.#{e} #{time} #{v}"
        end
        return back
      end

      def discover(*args)
        dbname = args[1]
        [ "postgres.db.discovery", "{\"{#DBNAME}\": \"#{dbname}\"}" ]
      end

      def get_status(status)
        ret = {}
        els = status.split "|"
        ret["numbackends"] = els[2]
        ret["xact_commit"] = els[3]
        ret["xact_rollback"] = els[4]
        ret["blks_read"] = els[5]
        ret["blks_hit"] = els[6]
        ret["tup_returned"] = els[7]
        ret["tup_fetched"] = els[8]
        ret["tup_inserted"] = els[9]
        ret["tup_updated"] = els[10]
        ret["tup_deleted"] = els[11]
        ret["conflicts"] = els[12]
        ret["temp_files"] = els[13]
        ret["temp_bytes"] = els[14]
        ret["deadlocks"] = els[15]
        ret["blk_read_time"] = els[16]
        ret["blk_write_time"] = els[17]
        ret
      end

      def get_activity(status)
        ar = { "active" => "0", "idle" => "0", "idle in transaction" => "0"}
        status.each_line.reduce([]) do |a,l|
          els = l.split("|").map(&:strip)
          ar[els[0]] = els[1]
        end
        ar
      end

      def get_writer(status)
        ret = {}
        els = status.split "|"
        ret["checkpoints_timed"] = els[1]
        ret["checkpoints_req"] = els[1]
        ret["checkpoint_write_time"] = els[2]
        ret["checkpoint_sync_time"] = els[3]
        ret["buffers_checkpoint"] = els[4]
        ret["buffers_clean"] = els[5]
        ret["maxwritten_clean"] = els[6]
        ret["buffers_backend"] = els[7]
        ret["buffers_backend_fsync"] = els[8]
        ret["buffers_alloc"] = els[9]
        ret
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('postgres', ZabbixRubyClient::Plugins::Postgres)

