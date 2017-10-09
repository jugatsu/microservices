require 'sinatra'
require 'json/ext' # for .to_json
require 'uri'
require 'mongo'
require './helpers'

mongo_host = ENV['COMMENT_DATABASE_HOST'] || '127.0.0.1'
mongo_port = ENV['COMMENT_DATABASE_PORT'] || '27017'
mongo_database = ENV['COMMENT_DATABASE'] || 'test'

configure do
  db = Mongo::Client.new(["#{mongo_host}:#{mongo_port}"], database: mongo_database, heartbeat_frequency: 2)
  set :mongo_db, db[:comments]
  set :bind, '0.0.0.0'
end

get '/:id/comments' do
  id   = object_id(params[:id])
  settings.mongo_db.find(post_id: "#{id}").to_a.to_json
end

post '/add_comment/?' do
  content_type :json
  halt 400, json(error: 'No name provided') if params['name'].nil? or params['name'].empty?
  halt 400, json(error: 'No comment provided') if params['body'].nil? or params['body'].empty?
  db = settings.mongo_db
  result = db.insert_one post_id: params['post_id'], name: params['name'], email: params['email'], body: params['body'], created_at: params['created_at']
  db.find(_id: result.inserted_id).to_a.first.to_json
end

get '/*' do |request|
  halt 404
end
