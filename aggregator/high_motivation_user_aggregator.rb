require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    results = []
    @channel_names.each do |name|
      count = load(name)['messages'].count
      results << {channel_name: name, message_count: count}
    end
    results.sort_by{|result| result[:message_count]}.reverse[0,3]
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end