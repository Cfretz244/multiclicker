#----- System Requires -----#

require 'json'
require 'redis'
require 'optimist'

#----- Config Options -----#

opts = Optimist.options do
  opt :redis_host, 'The host to connect to redis on', default: '127.0.0.1'
  opt :redis_port, 'The port to connect to redis on ', default: 7024
end

#----- Setup -----#

# Get redis handle
redis = Redis.new(host: opts[:redis_host], port: opts[:redis_port])

#----- Application Logic -----#

redis.subscribe('multiclicker') do |on|
  on.message do |_, msg|
    cmd = JSON.parse(msg)
    puts "Performing #{cmd['action']} click"
  end
end
