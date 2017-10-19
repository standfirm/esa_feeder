require 'dotenv/load'
require 'esa'

module EsaFeeder
  class Runner
    def initialize
      @client ||= Esa::Client.new(access_token: ENV['ESA_OWNER_API_TOKEN'], current_team: ENV['ESA_TEAM'])
    end

    def run
      client.posts(q: query).body['posts'].map do |post|
        client.create_post(template_post_id: post['number'])
      end
    end

    private

    attr_reader :client

    def query
      "in:templates tag:feed_#{Time.now.strftime('%a').downcase}"
    end
  end
end
