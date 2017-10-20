require 'dotenv/load'
require 'esa'
require 'slack-notifier'

module EsaFeeder
  class Runner
    def initialize
      @client = Esa::Client.new(access_token: ENV['ESA_OWNER_API_TOKEN'], current_team: ENV['ESA_TEAM'])
      @notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL']) if ENV['SLACK_WEBHOOK_URL']
    end

    def run(time: nil, user: 'esa_bot')
      time ||= Time.now
      client.posts(q: query(time)).body['posts'].map do |raw|
        post = to_esa_entity(raw)
        r = to_esa_entity(
          client.create_post(template_post_id: post.number, user: user).body
        )
        notify_slack(r.full_name, r.url) if notifier
        { post.number => r.number }
      end
    end

    private

    attr_reader :client, :notifier

    def query(time)
      "in:templates tag:feed_#{time.strftime('%a').downcase}"
    end

    def notify_slack(title, url)
      notifier.post attachments: [{
        pretext: '新しい記事を作成しました',
        title: title,
        title_link: url,
        color: 'good'
      }]
    end

    def to_esa_entity(raw)
      EsaFeeder::Entities::EsaPost.new(
        raw['number'],
        raw['full_name'],
        raw['url']
      )
    end
  end
end
