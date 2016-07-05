#! ruby
require 'httparty'
class KeepAlive
  attr_accessor :to_check
  def self.start
    every = env_load!('PING_EVERY_SECONDS', '30').to_i
    url = env_load! 'HEROKU_URL'
    global_logger.info "Starting keep alive checks against #{url} every #{every} sec"
    checker = self.new(url)
    loop do
      if checker.check
        global_logger.info "[keep-alive] check on #{checker.to_check} success!"
      else
        global_logger.warn "[keep-alive] check on #{checker.to_check} failed."
      end
      Kernel.sleep every
    end
  end
  def initialize(to_check)
    @to_check = to_check
  end
  def check
    HTTParty.get(@to_check).success?
  end
end

$children << Thread.new { KeepAlive.start }
