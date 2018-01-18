# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::SourceTag do
  let(:tags) do
    (0..6).map { |n| described_class.new(Time.local(2017, 4, 2 + n)).call }
  end
  let(:holiday_tags) { described_class.new(Time.local(2017, 11, 23)).call }

  let(:ref) { %w[sun mon tue wed thu fri sat] }

  it 'include tag each day of the week' do
    (0..6).map { |n| expect(tags[n]).to include("feed_#{ref[n]}") }
  end

  it 'include tag #feed_wday on weekdays' do
    (1..5).map { |n| expect(tags[n]).to include('feed_wday') }
  end

  it 'include tag #feed_eday on everyday' do
    (0..6).map { |n| expect(tags[n]).to include('feed_eday') }
  end

  it 'do not include tag #feed_wday on weekend' do
    expect(tags[0]).not_to include('feed_wday')
    expect(tags[6]).not_to include('feed_wday')
    expect(tags[0]).to include('feed_eday')
    expect(tags[6]).to include('feed_eday')
  end

  it 'do not include tag #feed_wday on public holiday' do
    expect(holiday_tags).not_to include('feed_wday')
    expect(holiday_tags).to include('feed_thu')
    expect(holiday_tags).to include('feed_eday')
  end
end
