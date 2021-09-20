class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    # dummy
    #各チャンネルのハッシュから、keyが“messages”のvalueの配列を取ってくる。6つの要素を連結して、messageが並んでいる配列であるmessages_aryを作る
    messages_ary = channel_names.map{|channel_name| load(channel_name)["messages"]}.flatten 
    
    #messages_aryの要素数と同じ要素数で、全ての要素に0が入っているcountという配列を作る
    count = Array.new(messages_ary.length).map{|n| n = 0}

    #messages_aryのi番目の要素のmessageに"reactions"というkeyが存在している時、"reactions"がkeyであるvalueを取ってくる
    #"reactions"がkeyであるvalueは、reactionの種類ごとにハッシュが入っている配列になっている
    #それぞれの種類のreaction（reactions[j]）について、"count"をcount[i]に足していく
    #以上の操作より、countという配列は、messages_aryのi番目の要素のreaction数が入った配列となる
    (0..messages_ary.length-1).each do |i|
      unless messages_ary[i]["reactions"].nil?
        reactions = messages_ary[i]["reactions"]
        (0..reactions.length-1).each do |j|
          count[i] += reactions[j]["count"]
        end
      end
    end  

    #配列countの要素の最大値と、最大値が入っている要素番号を特定する
    #配列messages_aryのその要素番号のmessageが該当のmessageであるため、そのmessageのkeyが"text"の値を取ってくる
    result = {:text=>messages_ary[count.index(count.max)]["text"], :reaction_count=>count.max}
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end