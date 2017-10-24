# frozen_string_literal: true

module EsaFeeder
  module UseCases
    class Feed
      def initialize(esa_port, notifier_port)
        @esa_port = esa_port
        @notifier_port = notifier_port
      end

      def call(tag: nil, user: 'esa_bot')
        tag ||= SourceTag.new.call
        esa_port.find_templates(tag).map do |template|
          post = esa_port.create_from_template(template, user)
          notifier_port&.notify_creation('新しい記事を作成しました', post)
          { template.number => post.number }
        end
      end

      private

      attr_reader :esa_port, :notifier_port
    end
  end
end
