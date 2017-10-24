# frozen_string_literal: true

require 'dotenv/load'

require 'esa_feeder/version'
require 'esa_feeder/entities/esa_post'
require 'esa_feeder/use_cases/feed'
require 'esa_feeder/use_cases/source_tag'
require 'esa_feeder/gateways/esa_client'
require 'esa_feeder/gateways/slack_client'

module EsaFeeder
  class << self
    def feed
      UseCases::Feed.new(esa_client, slack_client)
                    .call(SourceTag.new.call, 'esa_bot')
    end

    private

    def esa_client
      driver = Esa::Client.new(
        access_token: ENV['ESA_OWNER_API_TOKEN'],
        current_team: ENV['ESA_TEAM']
      )
      @esa_clinet ||= Gateways::EsaClient.new(driver)
    end

    def slack_client
      return unless ENV['SLACK_WEBHOOK_URL']
      @slack_client ||= Gateways::SlackClient.new(
        Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
      )
    end
  end
end
