
METHODS = %q{GET POST PUT DELETE OPTIONS HEAD TRACE}

class REST < Sinatra::Base
  require 'uri'
  require 'net/http'

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

  def build_method(method:, uri:)
    m = case method
        when 'GET'
          Net::HTTP::Get.new(uri)
        when 'POST'
          Net::HTTP::Post.new(uri)
        when 'PUT'
          Net::HTTP::Put.new(uri)
        when 'DELETE'
          Net::HTTP::Delete.new(uri)
        when 'OPTIONS'
          Net::HTTP::Options.new(uri)
        when 'HEAD'
          Net::HTTP::Head.new(uri)
        when 'TRACE'
          Net::HTTP::Trace.new(uri)
        end

    m
  end

  def make_connection(method:, address:, format:, content:)
    uri  = URI.parse(address)
    http = Net::HTTP.new(uri.host, uri.port)
    res  = build_method(method: method, uri: uri)

    res.content_type = format  unless format.empty?
    res.body         = content unless content.empty?
    answer = http.request(res)

    result                  = {return_code: answer.code}
    result[:content_type]   = answer['content-type'] if answer.key? 'content-type'
    result[:body]           = answer.body
    result[:content_length] = answer['content-length'] if answer.key? 'content-length'
    result[:all_headers]    = answer.to_hash
    result.to_json
  end

  post '/request' do
    method  = params['method'] || ''
    address = params['address'] || ''
    format  = params['format'] || ''
    content = params['content'] || ''

    content_type 'application/json'
    unless METHODS.include? method
      return {error: 'Unknown method type was provided'}.to_json
    end

    unless address =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      return {error: 'Invalid address was provided'}.to_json
    end


    unless format.empty? || MIME::Types.include?(format)
      return {error: 'Unknown Mime Type'}.to_json
    end

    make_connection(method: method, address: address, format: format, content: content)
  end

end
