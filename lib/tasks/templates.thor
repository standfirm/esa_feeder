require 'esa_feeder'

class Templates < Thor
  desc 'feed', 'create posts from templates with wday tag'
  def feed
    EsaFeeder::Runner.new.run
  end
end
