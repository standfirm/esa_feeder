require "spec_helper"
require "timecop"

RSpec.describe EsaFeeder::UseCases::Feed do
  let(:user) {'esa_bot'}
  let(:monday) { Time.local(2017, 10, 23) }
  let(:tuesday) { Time.local(2017, 10, 24) }

  let(:esa_client) {double('esa client')}
  let(:slack_client) {double('slack client')}

  let(:templates) {[
    EsaFeeder::Entities::EsaPost.new(1, 'templates/category/test_1 #feed_mon', 'https://example.com/posts/1'),
    EsaFeeder::Entities::EsaPost.new(2, 'templates/category/test_2 #feed_mon', 'https://example.com/posts/2'),
    EsaFeeder::Entities::EsaPost.new(3, 'templates/category/test_3 #feed_mon', 'https://example.com/posts/3'),
  ]}

  let(:posts) {[
    EsaFeeder::Entities::EsaPost.new(101, 'path/to/post/post_title_101 #feed_mon', 'https://example.com/posts/101'),
    EsaFeeder::Entities::EsaPost.new(102, 'path/to/post/post_title_102 #feed_mon', 'https://example.com/posts/102'),
    EsaFeeder::Entities::EsaPost.new(103, 'path/to/post/post_title_102 #feed_mon', 'https://example.com/posts/103'),
  ]}

  def mocking(tag)
    allow(esa_client).to receive(:find_templates).with("feed_#{tag}").and_return(templates)
    templates.each_with_index do |template, index|
      allow(esa_client).to receive(:create_from_template).with(template, user).and_return(posts[index])
    end
    allow(slack_client).to receive(:notify_creation)
  end

  context 'default' do
    before { mocking('mon') }

    it 'Monday' do
      Timecop.travel(monday) do
        expect(esa_client).to receive(:find_templates).with('feed_mon').once
        expect(esa_client).to receive(:create_from_template).exactly(templates.count)
        expect(slack_client).to receive(:notify_creation).exactly(templates.count)
        expect(described_class.new(esa_client, slack_client).call).to eq([{1 => 101}, {2 => 102}, {3 => 103},])
      end
    end
  end

  context 'assign time' do
    let(:templates) {[
      EsaFeeder::Entities::EsaPost.new(1, 'templates/category/test_1 #feed_tue', 'https://example.com/posts/1'),
      EsaFeeder::Entities::EsaPost.new(2, 'templates/category/test_2 #feed_tue', 'https://example.com/posts/2'),
    ]}

    let(:posts) {[
      EsaFeeder::Entities::EsaPost.new(101, 'path/to/post/post_title_101 #feed_tue', 'https://example.com/posts/101'),
      EsaFeeder::Entities::EsaPost.new(102, 'path/to/post/post_title_102 #feed_tue', 'https://example.com/posts/102'),
    ]}

    before { mocking('tue') }

    it 'Tuesday' do
      Timecop.travel(monday) do
        expect(esa_client).to receive(:find_templates).with('feed_tue').once
        expect(esa_client).to receive(:create_from_template).exactly(templates.count)
        expect(slack_client).to receive(:notify_creation).exactly(templates.count)
        expect(described_class.new(esa_client, slack_client).call(time: tuesday)).to eq([{1 => 101}, {2 => 102}])
      end
    end
  end

  context 'assign user' do
    let(:user) { 'another_user' }
    before { mocking('mon') }

    it 'called with user' do
      Timecop.travel(monday) do
        expect(esa_client).to receive(:find_templates).with('feed_mon').once
        expect(esa_client).to receive(:create_from_template).with(templates[0], user)
        expect(slack_client).to receive(:notify_creation).exactly(templates.count)
        expect(described_class.new(esa_client, slack_client).call(user: user)).to eq([{1 => 101}, {2 => 102}, {3 => 103},])
      end
    end
  end

  context 'slack notifier is empty' do
    before { mocking('mon') }

    it 'notify_creation not called' do
      Timecop.travel(monday) do
        expect(slack_client).not_to receive(:notify_creation)
        expect(described_class.new(esa_client, nil).call).to eq([{1 => 101}, {2 => 102}, {3 => 103},])
      end
    end
  end
end
