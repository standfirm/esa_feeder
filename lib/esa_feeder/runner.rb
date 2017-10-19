require 'dotenv/load'
require 'esa'

module EsaFeeder
  class Runner
    def initialize
      @client ||= Esa::Client.new(access_token: ENV['ESA_OWNER_API_TOKEN'], current_team: ENV['ESA_TEAM'])
    end

    def run(time: nil, user: 'esa_bot')
      time ||= Time.now
      client.posts(q: query(time)).body['posts'].map do |post|
        client.create_post(template_post_id: post['number'], user: user)
      end
    end

    private

    attr_reader :client

    def query(time)
      "in:templates tag:feed_#{time.strftime('%a').downcase}"
    end
  end
end
