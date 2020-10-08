#----- System Requires -----#

require 'thin'
require 'json'
require 'redis'
require 'sinatra'
require 'optimist'

#----- Config Options -----#

opts = Optimist.options do
  opt :redis_host, 'The host to connect to redis on', default: '127.0.0.1'
  opt :redis_port, 'The port to connect to redis on', default: 7024
  opt :redis_pass, 'The password to use with redis', default: 'hai_cpp_guild'
  opt :http_port, 'The port to accept HTTP connections on', default: 8080
end

set :bind, '0.0.0.0'
set :port, opts[:http_port]

#----- Setup -----#

# Get redis handle
redis = Redis.new(host: opts[:redis_host], port: opts[:redis_port], password: opts[:redis_pass])

#----- Application Logic -----#

get '/' do
  # Return bootstrap page
  File.read('assets/index.html')
end

post '/action' do
  # Key pressed, forward over redis
  redis.publish('multiclicker', params.to_json)
end
