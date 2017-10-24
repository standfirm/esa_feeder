require "spec_helper"

RSpec.describe EsaFeeder::Gateways::SlackClient do
  let(:post) { build(:esa_template, :with_slack_tag) }
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
                                  title: post.full_name,
                                  title_link: post.url,
                                  color: 'good'}],
                  channel: ['hoge'])

    target.notify_creation('message', post)
  end
end
