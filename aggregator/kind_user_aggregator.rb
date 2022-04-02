require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec

    results = Hash.new(0)
    @channel_names.each do |name|
      load(name)['messages'].each do |element|
        next unless element['reactions']
        users = element['reactions'].first['users']
        users.each do |user|
          user_sym = user.to_sym
          results[user_sym] += 1
        end
      end
    end
    # 出力データのフォーマットを合わせるために配列に変更
    results = results.sort_by{|_,v| v}.reverse.take(3).map{|data| {user_id: data[0], reaction_count: data[1]}}
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end