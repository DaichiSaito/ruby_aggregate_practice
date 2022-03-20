require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    message_ary = channel_names.map { |channel_name| load(channel_name)['messages'] }.flatten

    reaction_ary = message_ary.map { |message| message['reactions'] }.compact.flatten

    user_ary = reaction_ary.map { |reaction| reaction['users'] }.compact.flatten

    user_count = user_ary.uniq.map { |u| { user_id: u, reaction_count: user_ary.count(u) } }

    user_count.max_by(3) { |max| max[:reaction_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end
