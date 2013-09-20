require "open-uri"

module ZabbixRubyClient
  module Plugins
    module Apache
      extend self

      def collect(*args)
        host = args[0]
        logger.info "Apache collecting..."
        ret = get_status

        ret['Score'] = {
          "_" => 0,
          "S" => 0,
          "R" => 0,
          "W" => 0,
          "K" => 0,
          "D" => 0,
          "C" => 0,
          "L" => 0,
          "G" => 0,
          "I" => 0,
          "." => 0
        }
        ret["Scoreboard"].split("").each do |x|
          ret['Score'][x] += 1
        end
        ret.delete "Scoreboard"

        back = []
        back << "#{host} apache[TotalAccesses] #{ret["Total Accesses"]}"
        back << "#{host} apache[TotalKBytes] #{ret["Total kBytes"]}"
        back << "#{host} apache[CPULoad] #{ret["CPULoad"].to_f}"
        back << "#{host} apache[Uptime] #{ret["Uptime"]}"
        back << "#{host} apache[ReqPerSec] #{ret["ReqPerSec"].to_f}"
        back << "#{host} apache[BytesPerSec] #{ret["BytesPerSec"]}"
        back << "#{host} apache[BytesPerReq] #{ret["BytesPerReq"]}"
        back << "#{host} apache[BusyWorkers] #{ret["BusyWorkers"]}"
        back << "#{host} apache[IdleWorkers] #{ret["IdleWorkers"]}"
        back << "#{host} apache[c_idle] #{ret["Score"]["."]}"
        back << "#{host} apache[c_waiting] #{ret["Score"]["_"]}"
        back << "#{host} apache[c_closing] #{ret["Score"]["C"]}"
        back << "#{host} apache[c_dns] #{ret["Score"]["D"]}"
        back << "#{host} apache[c_finish] #{ret["Score"]["G"]}"
        back << "#{host} apache[c_cleanup] #{ret["Score"]["I"]}"
        back << "#{host} apache[c_keep] #{ret["Score"]["K"]}"
        back << "#{host} apache[c_log] #{ret["Score"]["L"]}"
        back << "#{host} apache[c_read] #{ret["Score"]["R"]}"
        back << "#{host} apache[c_send] #{ret["Score"]["W"]}"
        back << "#{host} apache[c_start] #{ret["Score"]["S"]}"

        return back
      end

      private

      def get_status
        ret = {}
        open "http://127.0.0.1:80/server-status?auto" do |f|
          f.each_line do |l|
            k, v = l.split ":"
            ret[k] = v.strip
          end
        end
        ret
      end

    end
  end
end

ZabbixRubyClient.register_plugin('apache', ZabbixRubyClient::Plugins::Apache)
