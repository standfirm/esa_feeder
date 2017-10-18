# frozen_string_literal: true

require 'rails_helper'

describe TemplatesController, type: :controller do
  before do
    get :index
  end

  it do
    expect(response).to be_ok
  end
end
