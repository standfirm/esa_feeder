# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::Entities::EsaPost do
  describe '#initialize' do
    let(:post) do
      described_class.new(
        99_999,
        'path/to/post/post_title #tag',
        'https://example.com/posts/99999',
        %w[feed_mon feed_tue]
      )
    end

    it 'can assign values' do
      expect(post.number).to eq(99_999)
      expect(post.full_name).to eq('path/to/post/post_title #tag')
      expect(post.url).to eq('https://example.com/posts/99999')
      expect(post.tags).to eq(%w[feed_mon feed_tue])
    end
  end

  describe '#slack_channels' do
    subject { post.slack_channels }

    context 'with slack tags' do
      let(:post) { build(:esa_template, :with_slack_tag) }
      it 'return only slack tag' do
        expect(subject).to eq(['hoge'])
      end
    end

    context 'with no slack tags' do
      let(:post) { build(:esa_template) }
      it 'return empty array' do
        expect(subject).to eq([])
      end
    end
  end
end
