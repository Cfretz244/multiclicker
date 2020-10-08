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

# Get redis handle
redis = Redis.new(host: opts[:redis_host], port: opts[:redis_port], password: opt[:redis_pass])

#----- Application Logic -----#

redis.subscribe('multiclicker') do |on|
  on.message do |_, msg|
    cmd = JSON.parse(msg)
    puts "Performing #{cmd['key']} click"
  end
end
