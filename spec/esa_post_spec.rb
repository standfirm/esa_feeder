require "spec_helper"

RSpec.describe EsaFeeder::Entities::EsaPost do
  let(:post) { described_class.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999') }

  it 'can assign values' do
    expect(post.number).to eq(99999)
    expect(post.full_name).to eq('path/to/post/post_title #tag')
    expect(post.url).to eq('https://example.com/posts/99999')
  end
end
