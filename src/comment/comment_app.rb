require 'sinatra'
require 'json/ext' # for .to_json
require 'uri'
require 'mongo'
require './helpers'
require 'prometheus/client'
require 'rufus-scheduler'

mongo_host = ENV['COMMENT_DATABASE_HOST'] || '127.0.0.1'
mongo_port = ENV['COMMENT_DATABASE_PORT'] || '27017'
mongo_database = ENV['COMMENT_DATABASE'] || 'test'


# Create and register metrics
prometheus = Prometheus::Client.registry

comment_health_gauge = Prometheus::Client::Gauge.new(:comment_health, 'Health status of Comment service')
comment_health_db_gauge = Prometheus::Client::Gauge.new(:comment_health_mongo_availability, 'Check if MongoDB is available to Comment')
comment_count = Prometheus::Client::Counter.new(:comment_count, 'A counter of new comments')
prometheus.register(comment_health_gauge)
prometheus.register(comment_health_db_gauge)
prometheus.register(comment_count)

## Schedule healthcheck function
build_info=File.readlines('build_info.txt')

scheduler = Rufus::Scheduler.new

scheduler.every '3s' do
  check = JSON.parse(healthcheck(mongo_host, mongo_port))
  comment_health_gauge.set({ version: check['version'].strip, commit_hash: build_info[0].strip, branch: build_info[1].strip }, check['status'])
  comment_health_db_gauge.set({ version: check['version'].strip, commit_hash: build_info[0].strip, branch: build_info[1].strip }, check['dependent_services']['commentdb'])
end


configure do
  db = Mongo::Client.new(["#{mongo_host}:#{mongo_port}"], database: mongo_database, heartbeat_frequency: 2)
  set :mongo_db, db[:comments]
  set :bind, '0.0.0.0'
end

get '/:id/comments' do
  id   = obj_id(params[:id])
  settings.mongo_db.find(post_id: "#{id}").to_a.to_json
end

post '/add_comment/?' do
  content_type :json
  halt 400, json(error: 'No name provided') if params['name'].nil? or params['name'].empty?
  halt 400, json(error: 'No comment provided') if params['body'].nil? or params['body'].empty?
  db = settings.mongo_db
  result = db.insert_one post_id: params['post_id'], name: params['name'], email: params['email'], body: params['body'], created_at: params['created_at']
  db.find(_id: result.inserted_id).to_a.first.to_json
  comment_count.increment
end

get '/healthcheck' do
  healthcheck(mongo_host, mongo_port)
end

get '/*' do |request|
  halt 404
end
