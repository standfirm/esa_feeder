require 'dotenv/load'
require 'esa'
require 'slack-notifier'

module EsaFeeder
  class Runner
    def initialize
      @client = EsaFeeder::Gateways::EsaClient.new(ENV['ESA_OWNER_API_TOKEN'], ENV['ESA_TEAM'])
      @notifier = EsaFeeder::Gateways::SlackClient.new(ENV['SLACK_WEBHOOK_URL']) if ENV['SLACK_WEBHOOK_URL']
    end

    def run(time: nil, user: 'esa_bot')
      time ||= Time.now
      client.find_templates(source_tag(time)).map do |template|
        post = client.create_from_template(template, user)
        notifier&.notify_creation('新しい記事を作成しました', post)
        { template.number => post.number }
      end
    end

    private

    attr_reader :client, :notifier

    def source_tag(time)
      "feed_#{time.strftime('%a').downcase}"
    end
  end
end
