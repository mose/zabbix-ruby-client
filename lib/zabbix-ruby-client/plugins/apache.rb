require "open-uri"

class ZabbixRubyClient
  module Plugins
    module Apache
      extend self

      def collect(*args)
        host = args[0]
        ret = get_status
        ret['Score'] = get_scores(ret["Scoreboard"])
        ret.delete "Scoreboard"

        time = Time.mow.to_i
        back = []
        back << "#{host} apache[TotalAccesses] #{time} #{ret["Total Accesses"]}"
        back << "#{host} apache[TotalKBytes] #{time} #{ret["Total kBytes"]}"
        back << "#{host} apache[CPULoad] #{time} #{ret["CPULoad"].to_f}"
        back << "#{host} apache[Uptime] #{time} #{ret["Uptime"]}"
        back << "#{host} apache[ReqPerSec] #{time} #{ret["ReqPerSec"].to_f}"
        back << "#{host} apache[BytesPerSec] #{time} #{ret["BytesPerSec"]}"
        back << "#{host} apache[BytesPerReq] #{time} #{ret["BytesPerReq"]}"
        back << "#{host} apache[BusyWorkers] #{time} #{ret["BusyWorkers"]}"
        back << "#{host} apache[IdleWorkers] #{time} #{ret["IdleWorkers"]}"
        back << "#{host} apache[c_idle] #{time} #{ret["Score"]["."]}"
        back << "#{host} apache[c_waiting] #{time} #{ret["Score"]["_"]}"
        back << "#{host} apache[c_closing] #{time} #{ret["Score"]["C"]}"
        back << "#{host} apache[c_dns] #{time} #{ret["Score"]["D"]}"
        back << "#{host} apache[c_finish] #{time} #{ret["Score"]["G"]}"
        back << "#{host} apache[c_cleanup] #{time} #{ret["Score"]["I"]}"
        back << "#{host} apache[c_keep] #{time} #{ret["Score"]["K"]}"
        back << "#{host} apache[c_log] #{time} #{ret["Score"]["L"]}"
        back << "#{host} apache[c_read] #{time} #{ret["Score"]["R"]}"
        back << "#{host} apache[c_send] #{time} #{ret["Score"]["W"]}"
        back << "#{host} apache[c_start] #{time}#{ret["Score"]["S"]}"
        return back
      end

      private

      def get_scores(board)
        back = {
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
        board.split("").each do |x|
          back[x] += 1
        end
        return back
      end

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

ZabbixRubyClient::Plugins.register('apache', ZabbixRubyClient::Plugins::Apache)
