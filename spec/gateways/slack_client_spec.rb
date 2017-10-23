require "spec_helper"

RSpec.describe EsaFeeder::Gateways::SlackClient do
  let(:post) { EsaFeeder::Entities::EsaPost.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999') }
  let(:driver) { double('slack notifier') }
  let(:target) { described_class.new(driver) }

  before do
    allow(driver).to receive(:post)
  end

  it '#notify_creation' do
    expect(driver)
      .to receive(:post)
      .once
      .with(attachments: [{
          pretext: 'message',
          title: 'path/to/post/post_title #tag',
          title_link: 'https://example.com/posts/99999',
          color: 'good' }])

    target.notify_creation('message', post)
  end
end
