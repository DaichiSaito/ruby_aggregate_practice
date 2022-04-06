require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    results = []
    @channel_names.map{|name|
      results << {
        channel_name: name,
        message_count: load(name)['messages'].count
      }
    }
    results.sort_by{|result| result[:message_count]}.reverse.take(3)
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end