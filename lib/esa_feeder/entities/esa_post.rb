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

      private

      def slack_tags
        tags.select { |tag| tag =~ /^slack_/ }
      end
    end
  end
end
