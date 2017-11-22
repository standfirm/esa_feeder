# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in esa_feeder.gemspec
gemspec

gem 'dotenv'
gem 'esa'
gem 'pry'
gem 'slack-notifier'
gem 'thor'

group :development, :test do
  gem 'rubocop'
end

group :test do
  gem 'factory_bot'
end
