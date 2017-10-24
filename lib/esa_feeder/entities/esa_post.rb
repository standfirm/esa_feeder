# frozen_string_literal: true

module EsaFeeder
  module Entities
    EsaPost = Struct.new(:number, :category, :name, :url, :tags) do
      def slack_channels
        tags.select { |tag| tag =~ /^slack_/ }
            .map { |tag| tag.gsub(/^slack_/, '') }
      end

      def full_name
        category ? "#{category}/#{name}" : name
      end
    end
  end
end
