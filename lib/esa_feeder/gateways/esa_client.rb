# frozen_string_literal: true

require 'esa'

module EsaFeeder
  module Gateways
    class EsaClient
      def initialize(driver)
        @driver = driver
      end

      def find_templates(tag)
        response = driver.posts(q: "category:templates -in:Archived tag:#{tag}")
        to_posts(response.body)
      end

      def find_expired_posts(category, date)
        response = driver.posts(q: "category:#{category} kind:flow -in:Archived updated:<#{date}")
        to_posts(response.body)
      end

      def create_from_template(post, user)
        response = driver.create_post(template_post_id: post.number, user: user)
        to_post(response.body)
      end

      def update_post(post, user)
        response = driver.update_post(
          post.number, tags: post.tags, category: post.category, updated_by: user
        )
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
          raw['category'],
          raw['name'],
          raw['url'],
          raw['tags']
        )
      end
    end
  end
end
