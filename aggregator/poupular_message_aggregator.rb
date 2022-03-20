class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    # dummy
    message_ary = channel_names.map { |channel_name| load(channel_name)["messages"] }.flatten
    # text_ary = message_ary.map{|message|{:text => message["text"],:reactions=> message["reactions"]}}.compact.flatten

    count = Array.new(message_ary.length).map { |n| n = 0 }

    message_ary.each_index do |i|
      reactions = message_ary[i]["reactions"]
      next if reactions.nil?
      reactions.each_index do |j|
        count[i] += reactions[j]["count"]
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
