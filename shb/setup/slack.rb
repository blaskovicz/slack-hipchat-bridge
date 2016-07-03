#! ruby
require 'slack'
require 'slack-ruby-bot'
SLACK_TAG = '[Slack]'
Slack.configure do |c|
  c.token = env_load! 'SLACK_API_TOKEN'
  c.logger = global_logger
end
def client_slack
  Slack::Web::Client.new
end
client_slack.auth_test # make sure we can connect

SlackRubyBot::Client.logger.level = global_logger_level
class ToHipChatBot < SlackRubyBot::Bot
  @@resolved_channels = {}
  @@resolved_users = {}
  match // do |client, data, match|
    # don't respond to our other half (hipchat -> slack posts)
    next if data.bot_id? and data.username? and data.username.index(HIPCHAT_TAG)
    # resolve the slack channel id to a name
    slack_channel = @@resolved_channels[data.channel]
    if slack_channel.nil?
      c=client_slack.channels_info(channel: data.channel)
      @@resolved_channels[data.channel] = c.channel.name
      slack_channel = c.channel.name
    end
    respond_channel = hipchat_room_for slack_channel
    # no mapping for this channel, ignore it
    next if respond_channel.nil?
    slack_user = @@resolved_users[data.user]
    if slack_user.nil?
      slack_user = if data.username?
        data.username
      # resolve user id to a name
      elsif data.user?
        u=client_slack.users_info(user: data.user)
        @@resolved_users[data.user] = u.user.name
        u.user.name
      else
        "? someone ?"
      end
    end
    username_field = if (slack_user.length + 1 + SLACK_TAG.length) > 20
      left=20
      left = left - 3 - 1 - SLACK_TAG.length
      slack_user.slice(0, left) + "... " + SLACK_TAG
    else
      "#{slack_user} #{SLACK_TAG}" #limit is 20 chars here
    end
    global_logger.info client_hipchat[respond_channel].send(
      username_field,
      data.text
    )
  end
end

$children << Thread.new { ToHipChatBot.run }
