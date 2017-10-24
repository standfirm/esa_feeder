# frozen_string_literal: true

module EsaFeeder
  module Entities
    EsaPost = Struct.new(:number, :full_name, :url, :tags) do
      def slack_channels
        tags.select { |tag| tag =~ /^slack_/ }
            .map { |tag| tag.gsub(/^slack_/, '') }
      end
    end
  end
end
