require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    #各チャンネルのハッシュから、keyが“messages”のvalueの配列を取ってくる。6つの要素を連結して、messageが並んでいる配列であるmessages_aryを作る
    messages_ary = channel_names.map{|channel_name| load(channel_name)["messages"]}.flatten 

    #各messageから、keyが“reactions”のvalueの配列を取ってくる。作成した配列を連結し、reactionが並んでいる配列であるreactions_aryを作る
    reactions_ary = []
    (0..messages_ary.length-1).each do |i|
      reactions_ary.push(messages_ary[i]["reactions"])
    end
    
    reactions_ary = reactions_ary.compact.flatten

    #各reactionから、keyが“users”のvalueの配列を取ってくる。作成した配列を連結し、userが並んでいる配列であるusers_aryを作る
    users_ary = []
    (0..reactions_ary.length-1).each do |j|
      users_ary.push(reactions_ary[j]["users"])
    end 

    users_ary = users_ary.flatten

    #users_aryに並んでいるuser_idが、スタンプを押したuserのuser_idである（複数回スタンプを押した場合は、重複して含まれる）
    #users_aryにuser_idがそれぞれ何個ずつ記載されているかを数えて、個数が多い方から3人のユーザー情報を抽出する
    users_count = []
    users_ary.uniq.each do |l|
      users_count.push({:user_id => l, :reaction_count => users_ary.count(l)})
    end
    
    desc = users_count.sort_by! { |i| i[:reaction_count] }.reverse!
    desc.first(3) 
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end