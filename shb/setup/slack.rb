#! ruby
require 'slack'
require 'logger'
Slack.configure do |c|
  c.token = env_load! 'SLACK_API_TOKEN'
  c.logger = global_logger
end
def client_slack
  Slack::Web::Client.new
end
client_slack.auth_test # make sure we can connect
