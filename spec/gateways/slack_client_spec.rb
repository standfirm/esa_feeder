require "spec_helper"

RSpec.describe EsaFeeder::Gateways::SlackClient do
  let(:post) { EsaFeeder::Entities::EsaPost.new(99999, 'path/to/post/post_title #tag', 'https://example.com/posts/99999') }

  it do
    driver = double('slack notifier')
    allow(driver).to receive(:post)
    slack_client = described_class.new(driver)

    expect(driver)
      .to receive(:post)
      .once
      .with(attachments: [{
          pretext: 'message',
          title: 'path/to/post/post_title #tag',
          title_link: 'https://example.com/posts/99999',
          color: 'good' }])

    slack_client.notify_creation('message', post)
  end
end
