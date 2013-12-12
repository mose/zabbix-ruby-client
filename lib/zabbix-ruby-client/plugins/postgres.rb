require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Postgres
      extend self

      def collect(*args)
        host = args[0]
        psqlargs = args[1]
        dbname = args[1]
        # be sure to have this in the config file
        # args: [ "-U username -h localhost", "dbname" ]
        # and setup username in a ~/.pgpass (0600) file for the zrc user
        # localhost:5432:dbname:username:password
        psqlstatus = `psql #{psqlargs} -A -t -c "select * from pg_stat_database where datname='#{dname}'" #{dbname}`
        if $?.to_i == 0
          status = get_status(psqlstatus)
        else
          Log.warn "The connection failed."
          return []
        end

        time = Time.now.to_i
        back = []
        status.each do |e,v|
          back << "#{host} mysql.status[#{e}] #{time} #{v}"
        end
        return back
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

    end
  end
end

ZabbixRubyClient::Plugins.register('postgres', ZabbixRubyClient::Plugins::Postgres)

