module ZabbixRubyClient
  module Plugins
    module Disk
      extend self

      def collect(*args)
        host = args[0]
        dev = args[1]
        diskinfo = `iostat -dx #{dev} | grep "^#{dev}"`
        if $?.to_i == 0
          _, rrqm, wrqm, r, w, rkb, wkb, avgrq, avgqu, await, rawait, wawait, svctm, util = diskinfo.split(/\s+/)
        else
          puts "Please install sysstat."
          return []
        end
        back = []
        back << "#{host} disk[#{dev},read_req_per_sec] #{rrqm}"
        back << "#{host} disk[#{dev},write_req_per_sec] #{wrqm}"
        back << "#{host} disk[#{dev},read_per_sec] #{r}"
        back << "#{host} disk[#{dev},write_per_sec] #{w}"
        back << "#{host} disk[#{dev},read_sector_per_sec] #{rkb}"
        back << "#{host} disk[#{dev},write_sector_per_sec] #{wkb}"
        back << "#{host} disk[#{dev},avg_sector_size] #{avgrq}"
        back << "#{host} disk[#{dev},avg_queue_length] #{avgqu}"
        back << "#{host} disk[#{dev},time_waiting] #{await}"
        back << "#{host} disk[#{dev},time_waiting_read] #{rawait}"
        back << "#{host} disk[#{dev},time_waiting_write] #{wawait}"
        back << "#{host} disk[#{dev},service_time] #{svctm}"
        back << "#{host} disk[#{dev},percent_util] #{util}"
        return back

      end

    end
  end
end

ZabbixRubyClient.register_plugin('disk', ZabbixRubyClient::Plugins::Disk)
