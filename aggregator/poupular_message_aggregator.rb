class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    result = {text: '', reaction_count: 0}
    @channel_names.each do |name|
      load(name)['messages'].each do |element|
        next unless element['reactions']
        count = element['reactions'].map{|re| re['users'].count}.sum
        if count > result[:reaction_count]
          result[:text] = element['text']
          result[:reaction_count] = count
        end
      end
    end
    result
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end