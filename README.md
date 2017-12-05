# EsaFeeder

[![CircleCI](https://circleci.com/gh/standfirm/esa_feeder.svg?style=svg)](https://circleci.com/gh/standfirm/esa_feeder)

[esa.io](https://esa.io/) のテンプレートから定期的に記事を自動作成するツールです。

## Features

繰り返し作成したい記事テンプレートに`#feed_xxx` タグを付けることで、そのテンプレートから記事を自動作成することができます。  
`xxx`部分は記事を作成したい曜日の短縮名、平日に作成したい場合は`wday`、毎日作成したい場合は'eday'です。以下のタグが使用できます。

- `#feed_sun`
- `#feed_mon`
- `#feed_tue`
- `#feed_wed`
- `#feed_thu`
- `#feed_fri`
- `#feed_sat`
- `#feed_wday`
- `#feed_eday`

`#feed_mon`を付けた記事は月曜日のみ自動記事作成の対象になります。  
複数指定も可能で、`#feed_mon #feed_fri`とすれば月曜日と金曜日に自動記事作成の対象になります。

`#feed_wday`をつけることで、平日(祝日を除く月曜日から金曜日)に自動作成されるようになります。  
日報などはこちらを使うと便利です。

なお、投稿テンプレートは通常のテンプレート(`templates/`以下)の他にユーザごとのテンプレート(`Users/[screen_name]/templates/`以下)にも対応しています。

### Notify to Slack

自動作成時に、Slackの任意のChannelへ通知することができます。  
`#slack_xxx` のようなタグを付けるとSlackの `#xxx` へ通知されます。
複数指定も可能です。

指定が無い場合は通知は飛びません。WebHook側の設定は上書きされます。

この機能を有効にするにはSLACK_WEBHOOK_URLの設定が必要です。

### Specify created by

記事の作成ユーザは、通常次の通りになります。

 - 通常のテンプレート(`templates/`以下): `esa_bot`
 - ユーザごとのテンプレート(`Users/[screen_name]/templates/`以下): `screen_name`のユーザ

このうち通常のテンプレートについては `#me_xxx` タグをつけることで作成ユーザを変更することができます。  
`xxx`の部分にはユーザのスクリーンネームを指定してください。

## How to Run

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

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


環境変数については、esaのチーム名とアクセストークンが指定必須です。  
Slack WebHook URLは入力すると記事が自動作成されたことを通知します。空の場合は通知をスキップします。

その後、Heroku Scheduler上で`bundle exec thor templates:feed`が毎日実行されるよう設定を行ってください。  
この際UTCでの設定になるため時差に注意してください。(0時に設定すると、日本時間9時に実行される)

## Test

```
$ bundle exec rspec spec/
```

でテストを実行できます。
