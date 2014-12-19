
class REST < Sinatra::Base

  configure do
    enable :logging, :sessions
    set :root, File.expand_path(File.join('../',File.basename(__FILE__)))
    set :public_folder, 'public'
    set :views, 'views'

    register Sinatra::Partial
    set :partial_template_engine, :haml
  end

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/' do
    haml :index
  end

  post '/request' do
  end

end
