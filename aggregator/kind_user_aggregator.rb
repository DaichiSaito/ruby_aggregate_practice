require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    #各チャンネルのハッシュから、keyが“messages”のvalueの配列を取ってくる。6つの要素を連結して、messageが並んでいる配列であるmessages_aryを作る
    message_ary = channel_names.map{|channel_name| load(channel_name)["messages"]}.flatten 

    #各messageから、keyが“reactions”のvalueの配列を取ってくる。作成した配列を連結し、reactionが並んでいる配列であるreactions_aryを作る
    reaction_ary = []
    (0..message_ary.length-1).each do |i|
      reaction_ary.push(message_ary[i]["reactions"])
    end
    
    reaction_ary = reaction_ary.compact.flatten

    #各reactionから、keyが“users”のvalueの配列を取ってくる。作成した配列を連結し、userが並んでいる配列であるusers_aryを作る
    user_ary = []
    (0..reaction_ary.length-1).each do |j|
      user_ary.push(reaction_ary[j]["users"])
    end 

    user_ary = user_ary.flatten

    #users_aryに並んでいるuser_idが、スタンプを押したuserのuser_idである（複数回スタンプを押した場合は、重複して含まれる）
    #users_aryにuser_idがそれぞれ何個ずつ記載されているかを数えて、個数が多い方から3人のユーザー情報を抽出する
    user_count = []
    user_ary.uniq.each do |l|
      user_count.push({:user_id => l, :reaction_count => user_ary.count(l)})
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