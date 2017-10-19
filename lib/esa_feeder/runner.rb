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
      client.posts(q: query(time)).body['posts'].map do |post|
        r = client.create_post(template_post_id: post['number'], user: user)
        notify_slack(r.body['full_name'], r.body['url']) if notifier
      end
    end

    private

    attr_reader :client, :notifier

    def query(time)
      "in:templates tag:feed_#{time.strftime('%a').downcase}"
    end

    def notify_slack(title, url)
      notifier.post text: "#{title}を作成しました / #{url}"
    end
  end
end
