require "spec_helper"

RSpec.describe EsaFeeder::Entities::EsaPost do
  let(:post) { described_class.new(99999, 'esa post title', 'esa post url') }

  it 'can assign values' do
    expect(post.number).to eq(99999)
    expect(post.full_name).to eq('esa post title')
    expect(post.url).to eq('esa post url')
  end
end
