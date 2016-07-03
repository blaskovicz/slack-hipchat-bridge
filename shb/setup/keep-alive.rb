#! ruby
require 'httparty'
class KeepAlive
  def self.start
    every = env_load! 'PING_EVERY_SECONDS', '30'
    url = env_load! 'HEROKU_URL'
    global_logger.info "Starting keep alive checks against #{url} every #{every} sec"
    checker = self.new(url)
    loop do
      if checker.check
        global_logger.info "[keep-alive] check on #{@to_check} success!"
      else
        global_logger.info "[keep-alive] check on #{@to_check} failed: #{r.inspect}"
      end
      Kernel.sleep every
    end
  end
  private
  def initialize(to_check)
    @to_check = to_check
  end
  def check
    r = HTTParty.get @to_check
    if r.is_success?
      true
    else
      false
    end
  end
end

$children << Thread.new { KeepAlive.start }
