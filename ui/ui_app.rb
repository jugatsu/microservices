require 'sinatra'
require 'sinatra/reloader'
require 'json/ext' # for .to_json
require 'haml'
require 'uri'
require 'rest-client'


post_service_host = ENV['POST_SERVICE_HOST'] || '127.0.0.1'
post_service_port = ENV['POST_SERVICE_PORT'] || '4567'
comment_service_host = ENV['COMMENT_SERVICE_HOST'] || '127.0.0.1'
comment_service_port = ENV['COMMENT_SERVICE_PORT'] || '4567'

configure do
  enable :sessions
  set :bind, '0.0.0.0'
end

before do
  session[:flashes] = [] if session[:flashes].class != Array
end


get '/' do
  @title = 'All posts'
  begin
    @posts = JSON.parse(RestClient::Request.execute(method: :get, url: "http://#{post_service_host}:#{post_service_port}/posts", timeout: 1))
  rescue
    session[:flashes] << { type: 'alert-danger', message: 'Can\'t show blog posts, some problems with the post service. <a href="." class="alert-link">Refresh?</a>' }
  end
  @flashes = session[:flashes]
  session[:flashes] = nil
  haml :index
end


get '/new' do
    @title = 'New post'
    @flashes = session[:flashes]
    session[:flashes] = nil
    haml :create
end


post '/new/?' do
  if params['link'] =~ URI::regexp
    begin
      RestClient.post(
                       "http://#{post_service_host}:#{post_service_port}/add_post",
                       title: params['title'],
                       link: params['link'],
                       created_at: Time.now.to_i
                     )
    rescue
      session[:flashes] << { type: 'alert-danger', message: 'Can\'t save your post, some problems with the post service' }
    else
      session[:flashes] << { type: 'alert-success', message: 'Post successuly published' }
    end
      redirect '/'
  else
    session[:flashes] << { type: 'alert-danger', message: 'Invalid URL' }
    redirect back
  end
end


post '/post/:id/vote/:type' do
  begin
    RestClient.post(
                    "http://#{post_service_host}:#{post_service_port}/vote",
                     id: params[:id],
                     type: params[:type]
                   )
  rescue
    session[:flashes] << { type: 'alert-danger', message: 'Can\'t vote, some problems with the post service' }
  end
    redirect back
end


get '/post/:id' do
  @post = JSON.parse(RestClient::Request.execute(method: :get, url: "http://#{post_service_host}:#{post_service_port}/post/#{params[:id]}", timeout: 3))
  @comments = JSON.parse(RestClient::Request.execute(method: :get, url: "http://#{comment_service_host}:#{comment_service_port}/#{params[:id]}/comments", timeout: 3))
  @flashes = session[:flashes]
  session[:flashes] = nil
  haml :show
end


post '/post/:id/comment' do
  begin
    RestClient.post(
                     "http://#{comment_service_host}:#{comment_service_port}/add_comment",
                     post_id: params[:id],
                     name: params[:name],
                     email: params['email'],
                     created_at: Time.now.to_i,
                     body: params['body']
                   )
  rescue
    session[:flashes] << { type: 'alert-danger', message: 'Can\'t save your comment, some problems with the comment service' }
  else
    session[:flashes] << { type: 'alert-success', message: 'Comment successuly published' }
  end
    redirect back
end
