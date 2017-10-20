require 'esa_feeder'
require 'logger'

class Templates < Thor
  desc 'feed', 'create posts from templates with wday tag'
  def feed
    logger = Logger.new(STDOUT)
    logger.info('feed task start')
    begin
      logger.info(EsaFeeder.feed)
    rescue => e
      logger.error(e)
    end
    logger.info('feed task finished')
  end
end
