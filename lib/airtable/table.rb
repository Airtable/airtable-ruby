module Airtable

  class Table < Resource

    # Fetch all records iterating through offsets
    def all
      offset = nil
      results = []
      begin
        records = self.class.get(worksheet_url, query: { 'limit' => 100, 'offset' => offset }).parsed_response
        results += records["records"].map { |r| Record.new(r["fields"].merge("id" => r["id"])) }
        offset = records["offset"]
      end until offset.nil?
      results
    end

    # Returns record based given row id
    def find(id)
      result = self.class.get(worksheet_url + "/" + id).parsed_response
      Record.new(result["fields"].merge("id" => result["id"])) if result.present? && result["id"].present?
    end

    # Creates a record by posting to airtable
    def create(record)
      result = self.class.post(worksheet_url,
        :body => { "fields" => record.fields }.to_json,
        :headers => { "Content-type" => "application/json" }).parsed_response
      if result.present? && result["id"].present?
        record.id = result["id"]
        record
      else # failed
        false
      end
    end

    # Replaces record in airtable based on id
    def update(record)
      result = self.class.put(worksheet_url + "/" + id,
        :body => { "fields" => record.fields }.to_json,
        :headers => { "Content-type" => "application/json" }).parsed_response
      if result.present? && result["id"].present?
        record
      else # failed
        false
      end
    end

    # Deletes record in table based on id
    def destroy(id)
      self.class.delete(worksheet_url + "/" + id).parsed_response
    end

    protected

    def worksheet_url
      "/#{app_token}/#{URI.encode(worksheet_name)}"
    end
  end # Table

end # Airtable