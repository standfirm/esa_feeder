# frozen_string_literal: true

FactoryBot.define do
  factory :esa_post, class: EsaFeeder::Entities::EsaPost do
    sequence :number
    category { 'path/to/post' }
    name { "post_title_#{number}" }
    url { "https://example.com/posts/#{number}" }
    tags %w[tag]

    factory :esa_template do
      tags %w[tag feed_mon]
      category { 'templates/path/to/post' }

      trait :with_slack_tag do
        tags %w[tag feed_mon slack_hoge hoge_slack_fuga]
      end
    end
  end
end
