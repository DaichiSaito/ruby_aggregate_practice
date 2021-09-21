## 前提
- 各チャンネルのデータは、{channel_name}.jsonファイルにJSON形式で保存されている。
- HighMotivationUser, AggregatorKindUserAggregator, PopularMessageAggregatorの各クラスの中に定義されているloadメソッドを使用することで、JSONファイルのデータをRubyのハッシュに変換できる。
（loadメソッドでは、jsonファイルにopenメソッド・loadメソッドを使うことでRubyのハッシュに変換している。）

- Loadメソッドを適用した各チャンネルのデータは、下記のような構造になっている。
{ “OK” => true, "messages" => messages, "has_more" => true, "pin_count" => 0, "response_metadata" => {“next_cursor": "bmV4dF90czoxNTEyMDg1ODYxMDAwNTQz"}}

- この時、messagesは下記のような配列である。
  - 要素数：各チャンネルに含まれるメッセージ数
  - 各要素の内容：そのチャンネルに投稿されたメッセージ（ハッシュで、メッセージを投稿したユーザーの情報やメッセージに対するスタンプ情報などを持っている）

- messagesという配列のデータ一例
 [{“type" => "message", "user" => "U012AB3CDE", "text" => “I find you punny and would like to smell your nose letter", "ts" => "1512085950.000216"},
{"type" => "message", "user" => "U061F7AUR", "text" => "What, you want to smell my shoes better?", "ts” => “1512104434.000490", "reactions” => [ {"name" => "+1", "users" => [ "U011L4JS3L3", "U01GM6WR59B", "U01HF9X6UET" ], "count” => 3}]}]

（各クラスの中では、load(channel_name)["messages”]で、各チャンネルのmessages配列を作ることができる）

## 課題1
- 各チャンネルのハッシュからkeyが“messages”のvalueの配列を取ってきて、その配列の要素数を出す（要素数が各チャンネルのメッセージ数）
- メッセージ数の降順で並び替え、メッセージ数が多い3つのチャンネルを抽出する

## 課題2
- 各チャンネルのハッシュからkeyが“messages”のvalueの配列を取ってきて、全チャンネルのメッセージが格納された配列を作成する
- 各メッセージから、keyが“reactions”のvalueの配列を取ってくる。作成した配列を連結し、全てのリアクションが並んでいる配列であるreactions_aryを作成する
- 各リアクションから、keyが“users”のvalueの配列を取ってくる。作成した配列を連結し、スタンプを押したユーザーが並んでいる配列であるusers_aryを作成する
- 各user_idがuser_aryにいくつずつ含まれているかを数えて、数が多い方から3人のユーザー情報を抽出する

## 課題3
- 各チャンネルのハッシュからkeyが“messages”のvalueの配列を取ってきて、全チャンネルのメッセージが格納された配列を作成する
- messages_aryの要素数と同じ要素数で、全ての要素に0が入っているcountという配列を作成する
- messages_aryのi番目の要素のmessageに"reactions"というkeyが存在している時、"reactions"がkeyであるvalueを取ってくる。それぞれの種類のreaction（reactions[j]）について、"count"をcount[i]に足していく。
以上の操作より、countという配列は、messages_aryのi番目の要素のreaction数が入った配列となる。
- countの要素の最大値と、最大値が入っている要素番号を特定する
- messages_aryのその要素番号のメッセージが該当のメッセージである。そのメッセージのkeyが"text”である値を取ってくる