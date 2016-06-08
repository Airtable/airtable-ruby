require 'airtable/httparty_patched_hash_conversions'

module Airtable
  # Base class for authorized resources sending network requests
  class Resource
    include HTTParty
    base_uri (ENV['AIRTABLE_ENDPOINT_URL'] || 'https://api.airtable.com/') + 'v0/'
    # debug_output $stdout

    attr_reader :api_key, :app_token, :worksheet_name

    query_string_normalizer(proc do |query|
      HTTParty::PatchedHashConversions.to_params(query)
    end)

    def initialize(api_key, app_token, worksheet_name)
      @api_key = api_key
      @app_token = app_token
      @worksheet_name = worksheet_name
      self.class.headers({'Authorization' => "Bearer #{@api_key}"})
    end
  end # AuthorizedResource
end # Airtable