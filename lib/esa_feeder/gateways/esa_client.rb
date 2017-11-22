# frozen_string_literal: true

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

      def update_post(post, user)
        response = driver.update_post(
          post.number, name: post.name, tags: post.tags, updated_by: user
        )
        to_post(response.body)
      end

      def token_screen_name
        driver.user.body['screen_name']
      end

      private

      attr_reader :driver

      def to_posts(body)
        body['posts'].map { |raw| to_post(raw) }
      end

      def to_post(raw)
        Entities::EsaPost.new(
          raw['number'],
          raw['category'],
          raw['name'],
          raw['url'],
          raw['tags']
        )
      end
    end
  end
end
