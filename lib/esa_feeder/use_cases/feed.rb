# frozen_string_literal: true

module EsaFeeder
  module UseCases
    class Feed
      def initialize(esa_port, notifier_port)
        @esa_port = esa_port
        @notifier_port = notifier_port
      end

      def call(tags, user)
        find_templates(tags).map do |template|
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

      def find_templates(tags)
        tags.map do |tag|
          esa_port.find_templates(tag)
        end.flatten
      end
    end
  end
end
