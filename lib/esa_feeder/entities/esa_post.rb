module EsaFeeder
  module Entities
    class EsaPost < Struct.new(:number, :full_name, :url, :tags)
      def slack_channels
        return nil if tags.nil?
        tags.select { |tag| tag=~ /slack_/ }.map { |tag| tag.gsub(/slack_/, '') }
      end
    end
  end
end
