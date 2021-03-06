# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::Gateways::EsaClient do
  let(:driver) { double('driver') }
  let(:target) { described_class.new(driver) }
  let(:template) { build(:esa_template) }

  describe '#find_templates' do
    let(:body) do
      { 'posts' => [
        'number' => template.number,
        'category' => template.category,
        'name' => template.name,
        'url' => template.url,
        'tags' => template.tags
      ] }
    end
    let(:response) { double('response', body: body) }

    subject { target.find_templates('test_tag') }

    it 'return templates' do
      query = 'category:templates -in:Archived tag:test_tag OR category:Templates -in:Archived tag:test_tag'

      allow(driver).to receive(:posts).with(q: query).and_return(response)
      expect(subject).to eq([template])
    end
  end

  describe '#create_from_template' do
    let(:post) { build(:esa_post) }
    let(:body) do
      { 'number' => post.number,
        'category' => post.category,
        'name' => post.name,
        'url' => post.url,
        'tags' => post.tags }
    end
    let(:response) { double('response', body: body) }

    before do
      allow(driver).to receive(:create_post)
        .with(template_post_id: template.number, user: 'bot_user')
        .and_return(response)
    end
    subject { target.create_from_template(template, 'bot_user') }

    it 'return created post' do
      expect(subject).to eq(post)
    end

    context 'api returns error' do
      let(:body) { { 'error' => 'some errors' } }

      it 'raise exeption' do
        expect { subject }.to raise_exception(EsaFeeder::Gateways::EsaClient::PostCreateError)
      end
    end
  end

  describe '#update_post' do
    let(:post) { build(:esa_post) }
    let(:body) do
      { 'number' => post.number,
        'category' => post.category,
        'name' => post.name,
        'url' => post.url,
        'tags' => post.tags }
    end
    let(:response) { double('response', body: body) }

    before do
      allow(driver).to receive(:update_post)
        .with(post.number, tags: post.tags, updated_by: 'bot_user')
        .and_return(response)
    end

    subject { target.update_post(post, 'bot_user') }

    it 'return updated post' do
      expect(subject).to eq(post)
    end

    context 'api returns error' do
      let(:body) { { 'error' => 'some errors' } }

      it 'raise exeption' do
        expect { subject }.to raise_exception(EsaFeeder::Gateways::EsaClient::PostUpdateError)
      end
    end
  end
end
