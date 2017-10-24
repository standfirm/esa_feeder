# frozen_string_literal: true

FactoryBot.define do
  factory :esa_post, class: EsaFeeder::Entities::EsaPost do
    sequence :number
    full_name { "path/to/post/post_title_#{number} #feed_mon" }
    url { "https://example.com/posts/#{number}" }
    tags %w[tag]

    factory :esa_template do
      tags %w[tag feed_mon]
      full_name { "templates/path/to/post/post_title_#{number} #feed_mon" }

      trait :with_slack_tag do
        tags %w[tag feed_mon slack_hoge hoge_slack_fuga]
      end
    end
  end
end
