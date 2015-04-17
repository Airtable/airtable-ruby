module Airtable
  # Base class for authorized resources sending network requests
  class Resource
    include HTTParty
    base_uri 'https://api.airtable.com/v0/'
    # debug_output $stdout

    attr_reader :api_key, :app_token, :worksheet_name

    def initialize(api_key, app_token, worksheet_name)
      @api_key = api_key
      @app_token = app_token
      @worksheet_name = worksheet_name
      self.class.headers({'Authorization' => "Bearer #{@api_key}"})
    end
  end # AuthorizedResource
end # Airtable