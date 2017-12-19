module Airtable
  # Response processor class
  class Response
    attr_accessor :raw, :result

    def initialize(raw_resp)
      @raw = raw_resp
      body = raw.body
      ::Airtable.logger.info "Response: #{body}" if ::Airtable.debug?
      begin
        @result = ::JSON.parse(body)
        @success = @raw.code.to_i == 200
      rescue
        @success = false
        @result = { 'raw' => body } if @result.blank?
      end
    end

    def success?
      @success
    end

    def rate_limited?
      @raw.code.to_i == 429
    end
  end
end
