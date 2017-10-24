require "spec_helper"

RSpec.describe EsaFeeder::Entities::EsaPost do
  let(:post) { described_class.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999', ['feed_mon', 'slack_hoge', 'feed_tue', 'slack_foo', 'hoge_slack_foo']) }
  let(:post_no_tag) { described_class.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999') }

  it 'can assign values' do
    expect(post.number).to eq(99999)
    expect(post.full_name).to eq('path/to/post/post_title #tag')
    expect(post.url).to eq('https://example.com/posts/99999')
    expect(post.tags).to eq(['feed_mon', 'slack_hoge', 'feed_tue', 'slack_foo', 'hoge_slack_foo'])
  end

  describe '#slack_channels' do
    context 'with tags' do
      subject { post.slack_channels }
      it 'return only slack tag' do
        expect(subject).to eq(['hoge', 'foo'])
      end
    end

    context 'with no tags' do
      subject { post_no_tag.slack_channels }
      it 'return empty array' do
        expect(subject).to be_nil
      end
    end
  end
end
