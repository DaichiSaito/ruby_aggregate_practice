require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    messages = @channel_names.map{|channel_name| load(channel_name)["messages"] }.flatten
    reactions = messages.map{|message| message["reactions"]if message.has_key?("reactions")}.compact.flatten
    all_reacted_users = reactions.map{|reaction| reaction["users"]}.flatten
    reaction_counts_by_user = all_reacted_users.group_by(&:itself).map{|k, v| [k, v.length]}
    sorted_targets = reaction_counts_by_user.sort{|a, b| b[1] <=> a[1]}[0..2]
    sorted_targets.map{|target| {:user_id => target[0], :reaction_count => target[1]}}
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end