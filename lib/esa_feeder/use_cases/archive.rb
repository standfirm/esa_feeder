# frozen_string_literal: true

module EsaFeeder
  module UseCases
    class Archive
      def initialize(esa_port)
        @esa_port = esa_port
      end

      def call(category, date)
        esa_port.find_expired_posts(category, monthes_ago(date)).map do |expired_post|
          expired_post.category = expired_post.archived_category
          esa_port.update_post(expired_post, 'esa_bot')
          { expired_post.number => 'Archived' }
        end
      end

      private

      attr_reader :esa_port

      def monthes_ago(monthes)
        date = Date.today << monthes.to_i
        "#{date.year}-#{format('%02d', date.month)}"
      end
    end
  end
end
