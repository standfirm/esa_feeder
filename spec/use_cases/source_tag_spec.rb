# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::SourceTag do
  let(:tags) do
    (0..6).map { |n| described_class.new(Time.local(2017, 1, 1 + n)).call }
  end

  let(:ref) { %w[sun mon tue wed thu fri sat] }

  it 'include tag each day of the week' do
    (0..6).map { |n| expect(tags[n]).to include("feed_#{ref[n]}") }
  end

  it 'include tag #feed_wday on weekdays' do
    (1..5).map { |n| expect(tags[n]).to include('feed_wday') }
  end

  it 'do not include tag #feed_wday on holiday' do
    expect(tags[0]).not_to include('feed_wday')
    expect(tags[6]).not_to include('feed_wday')
  end
end
