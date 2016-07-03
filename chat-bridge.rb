#! ruby
$children = []
if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end
require_relative 'shb/utils'
require_relative 'shb/setup/hipchat'
require_relative 'shb/setup/slack'
require_relative 'shb/setup/server'

Signal.trap('INT') do
  puts("Quitting...")
  abort
end
$children.each do |c|
  c.join
end
