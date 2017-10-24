# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EsaFeeder::UseCases::SourceTag do
  let(:tags) { (0..6).map { |n| described_class.new( Time.local(2017, 1, 1 + n) ).call} }
  let(:ref) {['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']}

  it 'check tag each day of the week' do
    (0..6).map { |n| expect(tags[n]).to eq("feed_#{ref[n]}") }
  end
end
