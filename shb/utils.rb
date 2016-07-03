#! ruby
require 'logger'
def hipchat_room_for(slack_room)
  slack2hipchat_room_map[slack_room]
end
def slack_room_for(hipchat_room)
  slack2hipchat_room_map.each do |key, value|
    if value == hipchat_room
      return key
    end
  end
end
def slack2hipchat_room_map
  return $room_map if $room_map
  #eg: SLACK2HIPCHAT_ROOM_MAP='slack-testing=hipchat-testing,general=@general'
  encoded_map = env_load! 'SLACK2HIPCHAT_ROOM_MAP'
  parsed_map = {}
  encoded_map.split(',').each do |single_mapping|
    slack_channel, hipchat_channel = single_mapping.split('=')
    next unless slack_channel && hipchat_channel
    slack_channel.sub! /^[@#]/, ''
    hipchat_channel.sub! /^[@#]/, ''
    parsed_map[slack_channel] = hipchat_channel
  end
  $room_map = parsed_map
  $room_map
end
def env_load!(var, default = nil)
  value = ENV[var]
  if value == nil
    value = default
  end
  if value.nil? || value == ""
    raise "Required environment variable #{var} missing!"
  end
  value
end
def global_logger
  logger = ::Logger.new(STDOUT)
  logger.level = env_load!('LOG_DEBUG', 'false') == 'true' ? Logger::DEBUG : Logger::INFO
  logger
end

slack2hipchat_room_map() # parse variable initially
