# EsaFeeder

[![CircleCI](https://circleci.com/gh/standfirm/esa_feeder.svg?style=svg&circle-token=b211037d0e100aae7eca4acea088966f26a71275)](https://circleci.com/gh/standfirm/esa_feeder)

[esa.io](https://esa.io/) のテンプレートから定期的に記事を自動作成するツールです。

## How to Use

繰り返し作成したい記事テンプレートを`templates/`以下に作成し、自動作成する曜日に応じた`#feed_xxx` タグを付けてください。　　  
`xxx`部分は記事を作成したい曜日の短縮名です。以下のタグが使用できます。

- `#feed_sun`
- `#feed_mon`
- `#feed_tue`
- `#feed_wed`
- `#feed_thu`
- `#feed_fri`
- `#feed_sat`

例えば`#feed_mon`を付けた記事は月曜日のみ自動記事作成の対象になります。  
複数指定も可能で、`#feed_mon #feed_fri`とすれば月曜日と金曜日に自動記事作成の対象になります。

### Run Locally

```
$ git checkout git@github.com:standfirm/esa_feeder.git
$ cd esa_feeder
$ bundle install
$ cp .env.sample .env
$ vi .env
// setup environment variable
```

で環境構築を行ってください。  
`bundle exec thor templates:feed`を実行することで、記事の自動作成が行われます。  
毎日実行されるようcronを設定することで、曜日に応じた記事が自動生成されるようになります。

### Run on Heroku

以下のボタンから[Heroku](https://dashboard.heroku.com/)にデプロイできます。

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/standfirm/esa_feeder/)


環境変数については、esaのチーム名とアクセストークンが指定必須です。  
Slack WebHook URLは入力すると記事が自動作成されたことを通知します。空の場合は通知をスキップします。

その後、Heroku Scheduler上で`bundle exec thor templates:feed`が毎日実行されるよう設定を行ってください。  
この際UTCでの設定になるため時差に注意してください。(0時に設定すると、日本時間9時に実行される)

## Test

```
$ bundle exec rspec spec/
```

でテストを実行できます。
