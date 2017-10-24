# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::SourceTag do
  let(:monday) { Time.local(2017, 10, 23) }

  subject { described_class.new(monday).call }

  it do
    expect(subject).to eq('feed_mon')
  end
end
