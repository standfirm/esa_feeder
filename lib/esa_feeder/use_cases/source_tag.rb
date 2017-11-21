# frozen_string_literal: true

module EsaFeeder
  module UseCases
    class SourceTag
      def initialize(time = nil)
        @time = time || Time.now
      end

      def call
        [day_of_the_week_feed, weekday_feed].reject(&:nil?)
      end

      private

      attr_reader :time

      def day_of_the_week_feed
        "feed_#{time.strftime('%a').downcase}"
      end

      def weekday_feed
        'feed_wday' unless [0, 6].include?(time.wday)
      end
    end
  end
end
