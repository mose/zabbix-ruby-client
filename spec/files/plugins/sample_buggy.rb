module SampleBuggy
  extend self

  def collect(*args)
    raise Exception.new
  end

end

ZabbixRubyClient::Plugins.register('sample_buggy', SampleBuggy)

