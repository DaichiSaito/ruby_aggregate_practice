class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  def exec
    message_ary = channel_names.map { |channel_name| load(channel_name)["messages"] }.flatten 
    
    count = Array.new(message_ary.length).map { |n| n = 0 }

    (0..message_ary.length - 1).each do |i|
      unless message_ary[i]["reactions"].nil?
        reactions = message_ary[i]["reactions"]
        (0..reactions.length-1).each do |j|
          count[i] += reactions[j]["count"]
        end
      end
    end

    { :text => message_ary[count.index(count.max)]["text"], :reaction_count => count.max }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end