require 'spec_helper'

RSpec.describe EsaFeeder::Gateways::EsaClient do
  let(:driver) { double('driver') }
  let(:target) { described_class.new(driver) }

  describe '#find_templates' do
    let(:body) do
      { 'posts' => [
        'number' => 99999,
        'full_name' => 'templates/category/test #feed_mon',
        'url' => 'https://example.com/posts/99999'
      ]}
    end
    let(:response) { double('response', body: body) }
    let(:post) {
      EsaFeeder::Entities::EsaPost.new(
        99999,
        'templates/category/test #feed_mon',
        'https://example.com/posts/99999'
      ) }

    subject { target.find_templates('test_tag') }

    it 'return templates' do
      allow(driver).to receive(:posts).with(q: 'in:templates tag:test_tag')
        .and_return(response)
      expect(subject).to eq([post])
    end
  end
end
