require 'esa'

module EsaFeeder
  module Gateways
    class EsaClient
      def initialize(driver)
        @driver = driver
      end

      def find_templates(tag)
        response = driver.posts(q: "in:templates tag:#{tag}")
        to_posts(response.body)
      end

      def create_from_template(post, user)
        response = driver.create_post(template_post_id: post.number, user: user)
        to_post(response.body)
      end

      private

      attr_reader :driver

      def to_posts(body)
        body['posts'].map { |raw| to_post(raw) }
      end

      def to_post(raw)
        Entities::EsaPost.new(
          raw['number'],
          raw['full_name'],
          raw['url'],
          raw['tags']
        )
      end
    end
  end
end
