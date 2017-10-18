class TemplatesController < ApplicationController
  def index
    @templates = client.posts(q: 'in:templates').body['posts']
  end

  private

  def client
    Esa::Client.new(
      access_token: ENV['ESA_OWNER_API_TOKEN'],
      current_team: ENV['ESA_TEAM']
    )
  end
end
