#! ruby
require 'thread'
if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end
# child thread objects
Thread.abort_on_exception = true
$children = []

require_relative 'shb/utils'
require_relative 'shb/setup/hipchat'
require_relative 'shb/setup/slack'
require_relative 'shb/setup/server'
require_relative 'shb/setup/keep-alive'

Signal.trap('INT') do
  puts("Interrupt: quitting...")
  abort
end
$children.each do |c|
  c.join
end
