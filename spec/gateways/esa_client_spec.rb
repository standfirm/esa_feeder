require 'spec_helper'

RSpec.describe EsaFeeder::Gateways::EsaClient do
  let(:driver) { double('driver') }
  let(:target) { described_class.new(driver) }
  let(:template) {
    EsaFeeder::Entities::EsaPost.new(
      99999,
      'templates/category/test #feed_mon',
      'https://example.com/posts/99999'
    ) }

  describe '#find_templates' do
    let(:body) do
      { 'posts' => [
        'number' => 99999,
        'full_name' => 'templates/category/test #feed_mon',
        'url' => 'https://example.com/posts/99999'
      ]}
    end
    let(:response) { double('response', body: body) }

    subject { target.find_templates('test_tag') }

    it 'return templates' do
      allow(driver).to receive(:posts).with(q: 'in:templates tag:test_tag')
        .and_return(response)
      expect(subject).to eq([template])
    end
  end

  describe '#create_from_template' do
    let(:body) do
      { 'number' => 12345,
        'full_name' => 'category/test #feed_mon',
        'url' => 'https://example.com/posts/12345' }
    end
    let(:response) { double('response', body: body) }
    let(:post) {
      EsaFeeder::Entities::EsaPost.new(
        12345,
        'category/test #feed_mon',
        'https://example.com/posts/12345'
      ) }

    subject { target.create_from_template(template, 'bot_user') }

    it 'return created post' do
      allow(driver).to receive(:create_post)
        .with(template_post_id: 99999, user: 'bot_user')
        .and_return(response)
      expect(subject).to eq(post)
    end
  end
end
