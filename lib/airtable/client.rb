# Allows access to data on airtable
#
# Fetch all records from table:
#
# client = Airtable::Client.new("keyPtVG4L4sVudsCx5W")
# client.table("appXXV84QuCy2BPgLk", "Table Name").all
#

module Airtable
  class Client
    def initialize(api_key)
      @api_key = api_key
    end

    # table("appXXV84QuCy2BPgLk", "Table 1")
    def table(app_token, table_name)
      Table.new(@api_key, app_token, table_name)
    end
  end # Client
end # Airtable
