class ZabbixRubyClient
  class Store

    def initialize(dir, server, task, keepdata)
      @dir = dir
      @server = server
      @task = task
      @keepdata = keepdata
      @basename = "#{@server}-#{@task}-data"
    end

    def datafile
      @datafile ||= if @keepdata
        unless Dir.exists? File.join(@dir, Time.now.strftime("%Y-%m-%d"))
          FileUtils.mkdir File.join(@dir, Time.now.strftime("%Y-%m-%d"))
        end
        File.join(@dir, Time.now.strftime("%Y-%m-%d"),"#{@basename}_"+Time.now.strftime("%H%M%S"))
      else
        File.join(@dir, @basename)
      end
    end

    def record(data)
      write(data, datafile, pending_content)
    end

    def keepdata(file)
      FileUtils.mv(file, @store.pendingfile)
    end

    def pendingfile
      @pendingfile ||= File.join(@dir, "#{@server}-pending")
    end

    def pending_content
      pending = ""
      if File.exists? pendingfile
        pending = File.open(pendingfile,'r').read
        File.delete(pendingfile)
      end
      pending
    end

    def write(data, file, prepend = "")
      File.open(file, "w") do |f|
        f.write(prepend)
        data.each do |d|
          f.puts d
        end
      end
      file
    end

  end
end
