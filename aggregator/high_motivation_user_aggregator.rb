require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    channel_bestsort = channel_names.map do |channel_name|
      {
        channel_name: channel_name,
        message_count: load(channel_name)['messages'].length
      }
    end
    channel_bestsort.max_by(3) { |max| max[:message_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end
