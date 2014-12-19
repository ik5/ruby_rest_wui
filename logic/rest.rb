
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

  def plain_answer(params)
    result = 'test'
    params.each_pair do |k,v|
      result << "\n<br>\n" + Rack::Utils.escape_html(k) + '='
      if v.kind_of? Array
        result << '[' + v.map{|i| Rack::Utils.escape_html(i)}.join(',') + ']'
      else
        result << Rack::Utils.escape_html(v)
      end
    end
    result
  end

  def plain_json(params)
    result =  { test: 'ack', params: nil }
    result[:params] = params unless params.keys.empty?

    result.to_json
  end

  def plain_xml(params)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root do
        xml.test do
          params.each_pair do |k,v|
            xml.params(key: k, value: v)
          end
        end
      end

    end
    builder.to_xml
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
