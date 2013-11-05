module SampleDiscover
  extend self

  def discover(*args)
    interface = args[0]
    [ "sample.discover", "{\"{#SAMPLE}\": \"#{interface}\"}" ]
  end

end

ZabbixRubyClient::Plugins.register('sample_discover', SampleDiscover)

