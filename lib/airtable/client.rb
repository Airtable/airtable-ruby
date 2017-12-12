module Airtable
  # Main client to Airtable
  class Client
    # @return [String] Airtable API Key
    attr_reader :api_key

    # Initialize new Airtable client
    # @param api_key [String] API Key for access Airtable
    # @return [::Airtable::Client] Airtable client object
    def initialize(api_key = nil)
      @api_key = api_key || ENV['AIRTABLE_KEY']
      raise Airtable::MissingApiKeyError if @api_key.nil? || @api_key.empty?
    end

    # Get the Base Airtable Entity by id
    # @param id [String] Id of Base on Airtable
    # @return [::Airtable::Entity::Base] Airtable Base entity object
    def base(id)
      ::Airtable::Entity::Base.new(id, self)
    end

    # table("appXXV84QuCy2BPgLk", "Sheet Name")
    # def table(app_token, worksheet_name)
    #   Table.new(@api_key, app_token, worksheet_name)
    # end
  end
end
