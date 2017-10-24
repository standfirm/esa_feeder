# frozen_string_literal: true

module EsaFeeder
  module UseCases
    class Feed
      def initialize(esa_port, notifier_port)
        @esa_port = esa_port
        @notifier_port = notifier_port
      end

      def call(time: nil, user: 'esa_bot')
        time ||= Time.now
        esa_port.find_templates(source_tag(time)).map do |template|
          post = esa_port.create_from_template(template, user)
          notifier_port&.notify_creation('新しい記事を作成しました', post)
          # remove system tags from generated post
          post.tags = post.user_tags
          esa_port.update_post(post, user)
          { template.number => post.number }
        end
      end

      private

      attr_reader :esa_port, :notifier_port

      def source_tag(time)
        "feed_#{time.strftime('%a').downcase}"
      end
    end
  end
end
