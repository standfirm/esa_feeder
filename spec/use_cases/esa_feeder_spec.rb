# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::Feed do
  let(:monday) { Time.local(2017, 10, 23) }
  let(:esa_client) { double('esa client') }

  let(:templates) { build_list(:esa_template, 2) }
  let(:posts) { build_list(:esa_post, 2) }

  let(:expected) do
    [
      { templates[0].number => posts[0].number },
      { templates[1].number => posts[1].number }
    ]
  end

  subject { described_class.new(esa_client, slack_client).call(time: monday) }

  before do
    expect(esa_client).to receive(:find_templates)
      .with('feed_mon').once
      .and_return(templates)
    expect(esa_client).to receive(:create_from_template)
      .with(templates[0], 'esa_bot').once
      .and_return(posts[0])
    expect(esa_client).to receive(:create_from_template)
      .with(templates[1], 'esa_bot').once
      .and_return(posts[1])
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
