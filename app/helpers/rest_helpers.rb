
require 'uri'
require 'net/http'

METHODS = %q{GET POST PUT DELETE OPTIONS HEAD TRACE}
module Sinatra

  module RESTHelper

    def escpae_uri(parameters)
      items = []
      parameters.each_pair do |k, v|
        if v.kind_of? Hash
          if v.key?('key') && v.key?('value')
            items << URI.escape(v['key']) + '=' + URI.escape(v['value'])
          end
        end
      end

      items.join('&')
    end

    def params_to_hash(parameters={})
      params = {}
      parameters.each_pair do |key, value|
        next unless value.key?('key') && value.key?('value')
        k,v = value['key'], value['value']
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

      if (method == 'POST' || method == 'PUT') && parameters
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

      result = []
      result << {key: :code, value: answer.code}
      result << {key: :content_type, value: answer['content-type']}    if answer.key? 'content-type'
      result << {key: :content_length, value:answer['content-length']} if answer.key? 'content-length'
      result << {key: :body, value: answer.body}
      result << {key: :uri, value: answer.uri}
      result << {key: :conten_range, value: answer.content_range}      if answer.content_range
      result << {key: :range, value: answer.range}                     if answer.range
      result << {key: :range_length, value: answer.range_length}       if answer.range_length
      result << {key: :chunked?, value: answer.chunked?}
      result << {key: :length, value: answer.length}
      result << {key: :sub_type, value: answer.sub_type}
      result << {key: :msg, value: answer.msg}
      answer.to_hash.each_pair do |k,v|
        if v.kind_of? Array
          v.each do |i|
            result << {key: k, value: i}
          end
        else
          result << {key: k, value: v}
        end
      end
      result.to_json
      #rescue => e
      #  {error: "Exception was raised: #{e.message}"}.to_json
    end

  end

end
