# frozen_string_literal: true

module EsaFeeder
  module UseCases
    class SourceTag
      def initialize(time = nil)
        @time = time || Time.now
      end

      def call
        "feed_#{time.strftime('%a').downcase}"
      end

      private

      attr_reader :time
    end
  end
end
