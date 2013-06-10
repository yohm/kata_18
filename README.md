# 西脇.rb&東灘.rb 第4回合同もくもく会
## やったことのまとめ
- Code KataのKata 18をやってみた
  - AはBに依存, BはCに依存... という依存関係から、Aが依存しているファイルの一覧を出力してみましょうという問題。
- どうせならば依存関係を可視化しようと思い、[d3.js](http://ja.d3js.node.ws/)のサイトからグラフのサンプルを取ってきて可視化してみた
  - 今回使ったのは[こちら](http://bl.ocks.org/mbostock/1044242)。
- （もくもく会後に）railsアプリのgemの依存関係を可視化してみた。

## 手順
### 依存関係の解析
- まずは安直に再帰を使って実装。[source](https://github.com/yohm/kata_18/commit/d021a46715cffd0333a5fe32561fc911a302e5f1)
- しかし、このコードでは循環がある場合に無限ループに入ってstack too deepで止まってしまう。
- 無限ループ対策を入れたコードが[こちら](https://github.com/yohm/kata_18/blob/master/lib/dependencies.rb)
  - 第二引数で、これまで検索したファイルについての情報を渡して無限ループしないようにした。
  - もう少し、すっきりとした（バグが無い事が一目で分かる）コードに書けそうな気がする。

### グラフ化
- d3.jsの[サンプル](http://bl.ocks.org/mbostock/1044242)の中を見たところ、jsonファイルを特定のフォーマットで出力すれば可視化できそう
- json化するメソッドを実装。[source](https://github.com/yohm/kata_18/blob/master/lib/dependencies.rb#L39)
- 出力したjsonを先ほどのhtmlの横に置いて、htmlファイルを開く
  - httpで開く必要があるので、Sinatraで簡易webサーバーをたてた
```
> ruby -rsinatra -e 'set :public_folder, "html"' -- -p 3000 -o 0.0.0.0
```

### Gemfile.lockの解析
- サンプルデータでは簡単すぎて面白くなかったので、railsアプリのgemを解析してみた
- rails apps composerでいろいろとgemをつけたrailsの仮アプリを作成
- bundle install で Gemfile.lock ができる。
- Gemfile.lockの簡易パーサーを書いて解析。
  - [bin/gemfile2json.rb](https://github.com/yohm/kata_18/blob/master/bin/gemfile2json.rb)
- 結果はこんな具合になった
![sample](https://raw.github.com/yohm/kata_18/master/html/screen_shot.png)

