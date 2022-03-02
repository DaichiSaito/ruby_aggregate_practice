class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    messages = @channel_names.map{|channel_name| load(channel_name)["messages"] }.flatten
    reaction_counts_by_id = []
    messages.each do |message|
      client_msg_id = message["client_msg_id"]
      if client_msg_id
        reaction_counts = message["reactions"].map{|reaction| reaction["count"] } if message["reactions"]
        reaction_counts_by_id << ["#{client_msg_id}", reaction_counts.sum] if reaction_counts
      end
    end
    target_message_info = reaction_counts_by_id.sort{|a, b| b[1] <=> a[1]}[0]
    target_message = messages.find{|message| message["client_msg_id"] == target_message_info[0]}
    {text: target_message["text"], reaction_count: target_message_info[1]}
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end