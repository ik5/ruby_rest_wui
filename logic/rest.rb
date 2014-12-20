
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

  def escpae_uri(parameters)
    parameters.map{|i| i.split('=').map{|a| URI.escape(a)}.join('=') }.join('&')
  end

  def params_to_hash(parameters={})
    params = {}
    parameters.each do |i|
      k,v = i.split('=')
      if params.key? k # array ?
        if params[k].kind_of? Array #already an array ?
          params[k] = params[k] + [v]
        else
          params[k] = [params[k], v]
        end
      else # not an array
        params[k] = v
      end
    end

    params
  end

  def build_method(method:, uri:, parameters: nil)
    resource = case method
        when 'GET'
          escaped    = escpae_uri(parameters) unless parameters.nil?
          escpaed  ||= ''
          uri.query  = escaped
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

    if (method == 'POST' || method == 'POST') && parameters
      params = params_to_hash(parameters)
      resource.set_form_data(params)
    end
    resource
  end

  def make_connection(method:, address:, format:, content:, parameters: nil)
    uri  = URI.parse(address)
    http = Net::HTTP.new(uri.host, uri.port)
    res  = build_method(method: method, uri: uri, parameters: parameters)

    res.content_type = format  unless format.empty?
    res.body         = content unless content.empty?
    answer = http.request(res)

    result                  = {return_code: answer.code}
    result[:content_type]   = answer['content-type'] if answer.key? 'content-type'
    result[:body]           = answer.body
    result[:content_length] = answer['content-length'] if answer.key? 'content-length'
    result[:all_headers]    = answer.to_hash
    result[:uri]            = answer.uri
    result.to_json
  rescue => e
    {error: "Exception was raised: #{e.message}"}.to_json
  end

  post '/request' do
    method     = params['method']     || ''
    address    = params['address']    || ''
    format     = params['format']     || ''
    content    = params['content']    || ''
    parameters = params['field_list'] || nil

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

    unless parameters.nil? || parameters.kind_of?(Array)
      return {error: 'Unknown type of parameters were given'}.to_json
    end

    make_connection(method: method, address: address,
                    format: format, content: content,
                    parameters: parameters
                   )
  end

end
