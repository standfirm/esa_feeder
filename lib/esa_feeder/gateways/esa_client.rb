require 'esa'

module EsaFeeder
  module Gateways
    class EsaClient
      def initialize(access_token, current_team)
        @client = Esa::Client.new(access_token: access_token, current_team: current_team)
      end

      def find_templates(tag)
        response = client.posts(q: "in:templates tag:#{tag}")
        to_entities(response.body)
      end

      def create_from_template(post, user)
        response = client.create_post(template_post_id: post.number, user: user)
        to_entity(response.body)
      end

      private

      attr_reader :client

      def to_entities(body)
        body['posts'].map { |raw| to_entity(raw) }
      end

      def to_entity(raw)
        Entities::EsaPost.new(
          raw['number'],
          raw['full_name'],
          raw['url']
        )
      end
    end
  end
end
