require "spec_helper"

RSpec.describe EsaFeeder::Entities::EsaPost do
  let(:post) { described_class.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999', ['feed_mon', 'feed_tue']) }
  let(:post_with_slack_tag) { described_class.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999', ['feed_mon', 'slack_hoge', 'hoge_slack_foo', 'slack_foo']) }

  it 'can assign values' do
    expect(post.number).to eq(99999)
    expect(post.full_name).to eq('path/to/post/post_title #tag')
    expect(post.url).to eq('https://example.com/posts/99999')
    expect(post.tags).to eq(['feed_mon', 'feed_tue'])
  end

  describe '#slack_channels' do
    context 'with slack tags' do
      subject { post_with_slack_tag.slack_channels }
      it 'return only slack tag' do
        expect(subject).to eq(['hoge', 'foo'])
      end
    end

    context 'with no slack tags' do
      subject { post.slack_channels }
      it 'return empty array' do
        expect(subject).to eq([])
      end
    end
  end
end
