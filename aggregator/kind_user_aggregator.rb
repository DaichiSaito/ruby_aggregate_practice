require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  def exec
    message_ary = channel_names.map { |channel_name| load(channel_name)["messages"] }.flatten

    reaction_ary = []
    (0..message_ary.length - 1).each do |i|
      reaction_ary.push(message_ary[i]["reactions"])
    end
    reaction_ary = reaction_ary.compact.flatten

    user_ary = []
    (0..reaction_ary.length - 1).each do |j|
      user_ary.push(reaction_ary[j]["users"])
    end
    user_ary = user_ary.flatten

    user_count = []
    user_ary.uniq.each do |l|
      user_count.push( { :user_id => l, :reaction_count => user_ary.count(l) } )
    end  
    
    desc = user_count.sort_by! { |i| i[:reaction_count] }.reverse!
    desc.first(3)
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end