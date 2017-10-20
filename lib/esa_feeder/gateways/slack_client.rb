module EsaFeeder
  module Gateways
    class SlackClient
      def initialize(webhook_url)
        @client = Slack::Notifier.new(webhook_url)
      end

      def notify_creation(message, post)
        client.post attachments: [{
          pretext: message,
          title: post.full_name,
          title_link: post.url,
          color: 'good'
        }]
      end

      private

      attr_reader :client
    end
  end
end
