# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::Feed do
  let(:esa_client) { double('esa client') }

  let(:templates) { build_list(:esa_template, 2) }
  let(:posts) do
    build_list(:esa_post, 2, tags: %w[hoge feed_mon fuga slack_test])
  end

  let(:expected) do
    [
      { templates[0].number => posts[0].number },
      { templates[1].number => posts[1].number }
    ]
  end

  subject do
    described_class.new(esa_client, slack_client).call('feed_mon', 'esa_bot')
  end

  before do
    expect(esa_client).to receive(:find_templates)
      .with('feed_mon').once
      .and_return(templates)
    (0..1).each do |n|
      expect(esa_client).to receive(:create_from_template)
        .with(templates[n], 'esa_bot').once
        .and_return(posts[n])
      expect(esa_client).to receive(:update_post)
        .with(
          have_attributes(number: posts[n].number,
                          tags: %w[hoge fuga]),
          'esa_bot'
        ).once
    end
  end

  context 'notifier provided' do
    let(:slack_client) { double('slack client') }
    it 'create posts and notify' do
      expect(slack_client).to receive(:notify_creation).exactly(templates.count)
      expect(subject).to eq(expected)
    end
  end

  context 'notifier not provided' do
    let(:slack_client) { nil }
    it 'create posts' do
      expect(subject).to eq(expected)
    end
  end
end
