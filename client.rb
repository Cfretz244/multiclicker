#----- System Requires -----#

require 'json'
require 'redis'
require 'optimist'

#----- Config Options -----#

opts = Optimist.options do
  opt :redis_host, 'The host to connect to redis on', default: '127.0.0.1'
  opt :redis_port, 'The port to connect to redis on', default: 7024
  opt :redis_pass, 'The password to use with redis', default: 'hai_cpp_guild'
end

#----- Setup -----#

KEYS = {
  'space' => 49,
  'up' => 126,
  'right' => 124,
  'down' => 125,
  'left' => 123
}

# Get redis handle
redis = Redis.new(host: opts[:redis_host], port: opts[:redis_port], password: opts[:redis_pass])

#----- Application Logic -----#

redis.subscribe('multiclicker') do |on|
  on.message do |_, msg|
    # Parse it
    cmd = JSON.parse(msg)
    raise 'Unregistered command received' unless KEYS.has_key?(cmd['key'])

    # Press it
    puts "Pressing key #{cmd['key']}..."
    `osascript -e 'tell application "System Events" to key code #{KEYS[cmd['key']]}'`
  end
end
