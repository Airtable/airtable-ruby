module Airtable

  # Contains records and the offset after a record query
  class RecordSet < SimpleDelegator

    attr_reader :records, :offset

    # results = { "records" => [{ ... }], "offset" => "abc5643" }
    # response from records api
    def initialize(results)
      # Parse records
      @records = results && results["records"] ?
        results["records"].map { |r| Record.new(r["fields"].merge("id" => r["id"])) } : []
      # Store offset
      @offset = results["offset"] if results
      # Assign delegation object
      __setobj__(@records)
    end

  end # Record

end # Airtable