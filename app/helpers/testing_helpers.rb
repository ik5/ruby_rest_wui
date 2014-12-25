
module Sinatra

  module TestingHelpers
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

  end

end
