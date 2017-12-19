require 'net/http'
require 'net/https'
require 'json'

module Airtable
  # Main Object that made all requests to server
  class Request
    METHODS = %i[get post put patch delete].freeze
    attr_accessor :url, :body, :headers, :http

    def initialize(url, body, token)
      @url     = URI(url)
      @body    = body
      @headers = {
        'Authorization' => "Bearer #{token}",
        'User-Agent'    => "Airtable gem v#{::Airtable::VERSION}",
        'Content-Type'  => 'application/json'
      }
    end

    def request(type = :get)
      @http   = setup_http
      request = setup_request(type)
      setup_headers(request)
      ::Airtable::Response.new(http.request(request))
    end

    private

    def setup_http
      http         = ::Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def setup_get_request
      ::Net::HTTP::Get.new(url.path + '?' + to_query_hash(body))
    end

    def setup_post_request
      request      = ::Net::HTTP::Post.new(url.path)
      request.body = body.to_json
      request
    end

    def setup_put_request
      request      = ::Net::HTTP::Put.new(url.path)
      request.body = body.to_json
      request
    end

    def setup_patch_request
      request      = ::Net::HTTP::Patch.new(url.path)
      request.body = body.to_json
      request
    end

    def setup_delete_request
      ::Net::HTTP::Delete.new(url.path)
    end

    def setup_request(type)
      raise ::Airtable::BrokenMethod unless METHODS.include?(type)
      __send__("setup_#{type}_request")
    end

    def setup_headers(request)
      headers.each do |name, value|
        request[name] = value
      end
    end

    def to_query_default(key, value)
      "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
    end

    def to_query_hash(hash, namespace = nil)
      hash.collect do |key, value|
        case value
        when ::Hash
          to_query_hash(value, namespace ? "#{namespace}[#{key}]" : key)
        when ::Array
          to_query_array(value, namespace ? "#{namespace}[#{key}]" : key)
        else
          to_query_default(namespace ? "#{namespace}[#{key}]" : key, value)
        end
      end.compact.sort! * '&'
    end

    def to_query_array(array, namespace)
      prefix = "#{namespace}[]"
      if array.empty?
        to_query_default(prefix, nil)
      else
        to_query_collect(array, prefix)
      end
    end

    def to_query_collect(array, prefix)
      array.collect do |value|
        case value
        when ::Hash
          to_query_hash(value, prefix)
        when ::Array
          to_query_array(value, prefix)
        else
          to_query_default(prefix, value)
        end
      end.join('&')
    end
  end
end
