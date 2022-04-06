require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    results = []
    users = []
    @channel_names.each do |name|
      load(name)['messages'].each do |element|
        reactions = element['reactions']
        next unless reactions
        users << reactions.map{|re| re['users']}
        users.flatten!
      end
    end
    users.uniq.each do |user|
      results << {user_id: user, reaction_count: users.count(user)}
    end
    results.sort_by{|re| re[:reaction_count]}.reverse.take(3)
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end