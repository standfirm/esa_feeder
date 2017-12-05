# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::Feed do
  let(:esa_client) { double('esa client') }
  let(:feed_users) { %w[esa_bot] }

  subject do
    described_class.new(esa_client, slack_client).call([tag])
  end

  let(:expected) do
    [
      { templates[0].number => posts[0].number },
      { templates[1].number => posts[1].number }
    ]
  end

  shared_context 'mock esa api' do |template_no, post_no, feed_user|
    before do
      expect(esa_client).to receive(:create_from_template)
        .with(templates[template_no], feed_user).once
        .and_return(posts[post_no])
      expect(esa_client).to receive(:update_post)
        .with(
          have_attributes(number: posts[post_no].number,
                          tags: %w[hoge fuga]), feed_user
        ).once
    end
  end

  shared_examples 'create post from templates' do
    before do
      expect(esa_client).to receive(:find_templates)
        .with(tag).once
        .and_return(templates)
    end

    context 'notifier provided' do
      let(:slack_client) { double('slack client') }
      it 'create posts and notify' do
        expect(slack_client).to receive(:notify_creation).exactly(expected.length)
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

  context 'mon_templates' do
    let(:templates) { build_list(:esa_template, 2) }
    let(:tag) { 'feed_mon' }
    let(:posts) do
      build_list(:esa_post, 2, tags: %w[hoge feed_mon fuga slack_test])
    end

    include_context 'mock esa api', 0, 0, 'esa_bot'
    include_context 'mock esa api', 1, 1, 'esa_bot'
    it_behaves_like 'create post from templates'
  end

  context 'wday_templates' do
    let(:templates) { build_list(:esa_template, 2, tags: %w[tag feed_wday]) }
    let(:tag) { 'feed_wday' }
    let(:posts) do
      build_list(:esa_post, 2, tags: %w[hoge feed_wday fuga slack_test])
    end

    include_context 'mock esa api', 0, 0, 'esa_bot'
    include_context 'mock esa api', 1, 1, 'esa_bot'
    it_behaves_like 'create post from templates'
  end

  context 'everyday_templates' do
    let(:templates) { build_list(:esa_template, 2, tags: %w[tag feed_eday]) }
    let(:tag) { 'feed_eday' }
    let(:posts) do
      build_list(:esa_post, 2, tags: %w[hoge feed_eday fuga slack_test])
    end

    include_context 'mock esa api', 0, 0, 'esa_bot'
    include_context 'mock esa api', 1, 1, 'esa_bot'
    it_behaves_like 'create post from templates'
  end

  context 'me_templates' do
    let(:templates) { build_list(:esa_template, 1, tags: %w[tag feed_wday me_hoge me_fuga]) }
    let(:tag) { 'feed_wday' }
    let(:feed_users) { %w[hoge fuga] }
    let(:posts) do
      build_list(:esa_post, 2, tags: %w[hoge feed_wday fuga me_hoge me_fuga])
    end

    let(:expected) do
      [
        { templates[0].number => posts[0].number },
        { templates[0].number => posts[1].number }
      ]
    end

    include_context 'mock esa api', 0, 0, 'hoge'
    include_context 'mock esa api', 0, 1, 'fuga'
    it_behaves_like 'create post from templates'
  end
end
