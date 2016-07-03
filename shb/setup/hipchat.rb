#! ruby
require 'hipbot'
require 'hipchat'
HIPCHAT_TAG = '[Hipchat]'
class ToSlackBot < Hipbot::Bot
  configure do |c|
    c.jid = env_load! 'HIPCHAT_JID'
    c.password = env_load! 'HIPCHAT_PASSWORD'
    c.join = "hubot-testing"
    c.logger = global_logger
  end
  on global: true do
    respond_channel = slack_room_for room.name
    # no mapping for this channel, ignore it
    next if respond_channel.nil?
    # don't respond to our other half (slack -> hipchat posts)
    next if message.sender.mention.index(SLACK_TAG)
    global_logger.info client_slack.chat_postMessage(
      channel: "##{respond_channel}",
      username: "#{message.sender.mention} #{HIPCHAT_TAG}",
      text: message.body,
      icon_emoji: ':speech_balloon:',
    )
  end
  # or else it will crash and burn...
  def self.with_response(response)
  end
end
def client_hipchat
  HipChat::Client.new(env_load!('HIPCHAT_API_TOKEN'), api_version: 'v2')
end
client_hipchat[slack2hipchat_room_map.values.first] #make sure the token is valid (TODO: can we use hipbot to respond somehow, and same with slack vs slackbot)?

$children << Thread.new { ToSlackBot.start! }
