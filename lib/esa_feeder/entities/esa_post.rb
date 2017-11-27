# frozen_string_literal: true

module EsaFeeder
  module Entities
    EsaPost = Struct.new(:number, :category, :name, :url, :tags) do
      def slack_channels
        slack_tags.map { |tag| tag.gsub(/^slack_/, '') }
      end

      def full_name
        category ? "#{category}/#{name}" : name
      end

      def user_tags
        tags - system_tags
      end

      def feed_users
        if me_tags.empty?
          ['esa_bot']
        else
          me_tags.map { |tag| tag.gsub(/^me_/, '') }
        end
      end

      private

      def system_tags
        feed_tags + slack_tags + me_tags
      end

      def feed_tags
        tags.select { |tag| tag =~ /^feed_/ }
      end

      def slack_tags
        tags.select { |tag| tag =~ /^slack_/ }
      end

      def me_tags
        tags.select { |tag| tag =~ /^me_/ }
      end
    end
  end
end
