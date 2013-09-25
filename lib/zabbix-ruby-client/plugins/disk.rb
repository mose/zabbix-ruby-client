class ZabbixRubyClient
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
          logger.warn "Please install sysstat."
          return []
        end
        diskspace = `df | grep "#{dev}"`
        if $?.to_i == 0
          _, _, used, available, percent_used, mount = diskspace.split(/\s+/)
        else
          logger.error "df is not working... ouchie."
          return []
        end
        back = []
        back << "#{host} disk.io[#{dev},read_req_per_sec] #{rrqm}"
        back << "#{host} disk.io[#{dev},write_req_per_sec] #{wrqm}"
        back << "#{host} disk.io[#{dev},read_per_sec] #{r}"
        back << "#{host} disk.io[#{dev},write_per_sec] #{w}"
        back << "#{host} disk.io[#{dev},read_sector_per_sec] #{rkb}"
        back << "#{host} disk.io[#{dev},write_sector_per_sec] #{wkb}"
        back << "#{host} disk.io[#{dev},avg_sector_size] #{avgrq}"
        back << "#{host} disk.io[#{dev},avg_queue_length] #{avgqu}"
        back << "#{host} disk.io[#{dev},time_waiting] #{await}"
        back << "#{host} disk.io[#{dev},time_waiting_read] #{rawait}"
        back << "#{host} disk.io[#{dev},time_waiting_write] #{wawait}"
        back << "#{host} disk.io[#{dev},service_time] #{svctm}"
        back << "#{host} disk.io[#{dev},percent_util] #{util}"
        back << "#{host} disk.space[#{dev},used] #{used}"
        back << "#{host} disk.space[#{dev},available] #{available}"
        back << "#{host} disk.space[#{dev},percent_used] #{percent_used.gsub(/%/,'')}"
        return back
      end

      def discover(*args)
        device = args[0]
        mount = args[1]
        [ "disk.dev.discovery", "{\"{#DISK_DEVICE}\": \"#{device}\", \"{#DISK_MOUNT}\": \"#{mount}\"}" ]
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('disk', ZabbixRubyClient::Plugins::Disk)
