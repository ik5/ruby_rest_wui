require_relative '../helpers/rest_helpers'

class REST < Sinatra::Base
  helpers Sinatra::RESTHelper

  configure do
    enable :logging, :sessions
    set :root, File.expand_path(File.join('..','..',File.basename(__FILE__)))
    set :public_folder, File.join('app', 'assets')
    set :views, File.join('app' ,'templates')

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

    unless parameters.nil? || parameters.kind_of?(Hash)
      return {error: 'Unknown type of parameters were given'}.to_json
    end

    make_connection(method: method, address: address,
                    format: format, content: content,
                    parameters: parameters
                   )
  end

end
