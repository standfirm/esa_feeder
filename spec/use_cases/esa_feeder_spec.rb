require "spec_helper"
require "timecop"

RSpec.describe EsaFeeder::UseCases::Feed do
  let(:monday) { Time.local(2017, 10, 23) }

  let(:esa_client) {double('esa client')}
  let(:slack_client) {double('slack client')}

  let(:templates) {[
    EsaFeeder::Entities::EsaPost.new(1, 'templates/category/test_1 #feed_mon', 'https://example.com/posts/1'),
    EsaFeeder::Entities::EsaPost.new(2, 'templates/category/test_2 #feed_mon', 'https://example.com/posts/2'),
  ]}

  let(:posts) {[
    EsaFeeder::Entities::EsaPost.new(101, 'path/to/post/post_title_101 #feed_mon', 'https://example.com/posts/101'),
    EsaFeeder::Entities::EsaPost.new(102, 'path/to/post/post_title_102 #feed_mon', 'https://example.com/posts/102'),
  ]}

  def mocking(tag)
    allow(esa_client).to receive(:find_templates).with("feed_#{tag}").and_return(templates)
    templates.each_with_index do |template, index|
      allow(esa_client).to receive(:create_from_template).with(template, 'esa_bot').and_return(posts[index])
    end
    allow(slack_client).to receive(:notify_creation)
  end

  before do
    mocking('mon')
  end

  context 'default' do
    it 'called on Monday' do
      Timecop.travel(monday) do
        expect(esa_client).to receive(:find_templates).with('feed_mon').once
        expect(esa_client).to receive(:create_from_template).with(templates[0], 'esa_bot').once
        expect(esa_client).to receive(:create_from_template).with(templates[1], 'esa_bot').once
        expect(slack_client).to receive(:notify_creation).exactly(templates.count)
        expect(described_class.new(esa_client, slack_client).call).to eq([{1 => 101}, {2 => 102}])
      end
    end
  end

  context 'slack notifier is empty' do
    it 'notify_creation not called' do
      Timecop.travel(monday) do
        expect(slack_client).not_to receive(:notify_creation)
        expect(described_class.new(esa_client, nil).call).to eq([{1 => 101}, {2 => 102}])
      end
    end
  end
end
