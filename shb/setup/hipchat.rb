#! ruby
require 'hipbot'
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
    return if respond_channel.nil?
    header = "_#{message.sender.name} (@#{message.sender.mention}) via HipChat ##{room.name} says..._"
    global_logger.info client_slack.chat_postMessage(channel: "##{respond_channel}", text: "#{header}\n#{message.body}")
  end
  # or else it will crash and burn...
  def self.with_response(response)
  end
end

$children << Thread.new { ToSlackBot.start! }
