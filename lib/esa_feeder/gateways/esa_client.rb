require 'esa'

module EsaFeeder
  module Gateways
    class EsaClient
      def initialize(access_token, current_team)
        @client = Esa::Client.new(access_token: access_token, current_team: current_team)
      end

      def find_templates(tag)
        response = client.posts(q: "in:templates tag:#{tag}")
        to_posts(response.body)
      end

      def create_from_template(post, user)
        response = client.create_post(template_post_id: post.number, user: user)
        to_post(response.body)
      end

      private

      attr_reader :client

      def to_posts(body)
        body['posts'].map { |raw| to_post(raw) }
      end

      def to_post(raw)
        Entities::EsaPost.new(
          raw['number'],
          raw['full_name'],
          raw['url']
        )
      end
    end
  end
end
