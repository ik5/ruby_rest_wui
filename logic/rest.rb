
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

  get '/test_get' do
    'test'
  end

  get '/test_json' do
    content_type 'application/json'
    result =  { test: 'ack', params: nil }
    result[:params] = params unless params.keys.empty?

    result.to_json
  end

  get '/test_xml' do
    content_type 'application/xml'
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root do
        xml.test do
          params.each_pair do |k,v|
            xml.params(key: k, value: v)
          end
        end
      end

      builder.to_xml
    end
  end

  post '/test_post' do
    result = ''
    params.each_pair do |k,v|
      result << Rack::Utils.escape_html(k) + '=' + Rack::Utils.escape_html(v)
    end

    result
  end

  post '/test_json' do
    params.to_json
  end

  post '/test_xml' do
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.params do
        params.each_pair do |k,v|
          xml.param(key: k, value: v)
        end
      end
    end

    builder
  end

  put '/test_put/:id' do |id|
  end

  put '/test_json/:id' do |id|
  end

  put '/test_xml/:id' do |id|
  end

  delete '/test_delete/:id' do |id|
  end

  delete '/test_json/:id' do |id|
  end

  delete '/test_xml/:id' do |id|
  end

end
