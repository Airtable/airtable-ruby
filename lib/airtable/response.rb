module Airtable
  class Response
    attr_accessor :raw, :result

    def initialize(raw_response)
      @raw = raw_response
      begin
        @result = ::JSON.parse(raw.body)
        ::Airtable.logger.info "Response: #{@result}"
        @success = @raw.code.to_i == 200
      rescue
        @success = false
        ::Airtable.logger.info "ERROR Response: #{raw.body}"
        @result = { 'detail' => raw.body } if @result.blank?
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
