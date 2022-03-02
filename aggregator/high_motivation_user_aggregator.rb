require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    msg_count = @channel_names.map{|channel_name| 
      data = load(channel_name)["messages"]
      [channel_name, data.length]
    }
    sorted_targets = msg_count.sort{|a, b| b[1] <=> a[1]}[0..2]
    sorted_targets.map{|target| {:channel_name => target[0], :message_count => target[1]}}
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end