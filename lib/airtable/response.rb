module Airtable
  # Response processor class
  class Response
    attr_accessor :raw, :result

    def initialize(raw_resp)
      @raw = raw_resp
      body = raw.body
      ::Airtable.logger.info "Response: #{body}" if ::Airtable.debug?
      @result  = ::JSON.parse(body)
      @success = @raw.code.to_i == 200
    end

    def success?
      @success
    end
  end
end
