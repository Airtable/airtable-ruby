require 'net/http'
require 'net/https'

module Airtable
  class Request
    attr_accessor :url, :body, :headers, :http

    def initialize(url, body, token)
      @url     = URI(url)
      @body    = body
      @headers = {
        'Authorization' => "Bearer #{token}",
        'Content-Type'  => 'application/json'
      }
    end

    def request(type = :get)
      @http   = setup_http
      request = setup_request(type)
      setup_headers(request)
      ::Airtable::Response.new(http.request(request))
    end

    def setup_http
      http         = ::Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def setup_get_request
      request = ::Net::HTTP::Get.new(url.path)
      request.set_form_data(body)
      ::Net::HTTP::Get.new(url.path + '?' + request.body)
    end

    def setup_post_request
      request      = ::Net::HTTP::Post.new(url.path)
      request.body = body
      request
    end

    def setup_put_request
      request      = ::Net::HTTP::Put.new(url.path)
      request.body = body.to_json
      request
    end

    def setup_request(type)
      case type
      when :get
        setup_get_request
      when :post
        setup_post_request
      when :put
        setup_put_request
      end
    end

    def setup_headers(request)
      headers.each do |name, value|
        request[name] = value
      end
    end
  end
end
