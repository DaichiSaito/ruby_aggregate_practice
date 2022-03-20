require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    message_count = channel_names.map{
      |channel_name| {
        :channel_name => channel_name,
        :message_count => load(channel_name)["messages"].length
      }
    }
    desc = message_count.sort_by! { |a| a[:message_count] }.reverse!
    desc.first(3)
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end
