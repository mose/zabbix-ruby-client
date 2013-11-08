module SampleBuggy
  extend self

  def collect(*args)
    raise Exception
  end

end

ZabbixRubyClient::Plugins.register('sample_buggy', SampleBuggy)

