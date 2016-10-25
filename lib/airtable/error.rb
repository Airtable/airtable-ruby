
module Airtable
  class Error < StandardError

    attr_reader :message, :type
    # {"error"=>{"type"=>"UNKNOWN_COLUMN_NAME", "message"=>"Could not find fields foo"}}

    def initialize(error_hash)
      @message = error_hash['message']
      @type = error_hash['type']
      super(@message)
    end

  end
end
