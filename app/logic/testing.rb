require_relative '../helpers/testing_helpers'

class Testing < Sinatra::Base

  helpers Sinatra::TestingHelpers

  configure do
    set :root, File.expand_path(File.join('../',File.basename(__FILE__)))
    enable :logging
  end

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/test_get' do
    plain_answer(params)
  end

  get '/test_json' do
    content_type 'application/json'
    plain_json(params)
  end

  get '/test_xml' do
    content_type 'application/xml'
    plain_xml(params)
  end

  post '/test_post' do
    plain_answer(params)
  end

  post '/test_json' do
    content_type 'application/json'
    plain_json(params)
  end

  post '/test_xml' do
    content_type 'application/xml'
    plain_xml(params)
  end

  put '/test_put/:id' do |id|
    params['path_id'] = id
    plain_answer(params)
  end

  put '/test_json/:id' do |id|
    content_type 'application/json'
    params['path_id'] = id
    plain_json(params)
  end

  put '/test_xml/:id' do |id|
    content_type 'application/xml'
    params['path_id'] = id
    plain_xml(params)
  end

  delete '/test_delete/:id' do |id|
    params['path_id'] = id
    plain_answer(params)
  end

  delete '/test_json/:id' do |id|
    content_type 'application/json'
    params['path_id'] = id
    plain_json(params)
  end

  delete '/test_xml/:id' do |id|
    content_type 'application/xml'
    params['path_id'] = id
    plain_xml(params)
  end

end
