require 'test_helper'

describe Airtable do
  before do
    @client_key = "12345"
    @app_key = "appXXV84Qu"
    @sheet_name = "Test"
  end

  describe "with Airtable" do
    it "should allow client to be created" do
      @client = Airtable::Client.new(@client_key)
      assert_kind_of Airtable::Client, @client
      @table = @client.table(@app_key, @sheet_name)
      assert_kind_of Airtable::Table, @table
    end

    it "should fetch record set" do
      stub_airtable_response!("https://api.airtable.com/v0/#{@app_key}/#{@sheet_name}", { "records" => [], "offset" => "abcde" })
      @table = Airtable::Client.new(@client_key).table(@app_key, @sheet_name)
      @records = @table.records
      assert_equal "abcde", @records.offset
    end

    it "should allow creating records" do
      stub_airtable_response!("https://api.airtable.com/v0/#{@app_key}/#{@sheet_name}",
        { "fields" => { "name" => "Sarah Jaine", "email" => "sarah@jaine.com", "foo" => "bar" }, "id" => "12345" }, :post)
      table = Airtable::Client.new(@client_key).table(@app_key, @sheet_name)
      record = Airtable::Record.new(:name => "Sarah Jaine", :email => "sarah@jaine.com")
      table.create(record)
      assert_equal "12345", record["id"]
      assert_equal "bar", record["foo"]
    end

    it "should allow updating records" do
        record_id = "12345"
        stub_airtable_response!("https://api.airtable.com/v0/#{@app_key}/#{@sheet_name}/#{record_id}",
          { "fields" => { "name" => "Sarah Jaine", "email" => "sarah@jaine.com", "foo" => "bar" }, "id" => record_id }, :put)
        table = Airtable::Client.new(@client_key).table(@app_key, @sheet_name)
        record = Airtable::Record.new(:name => "Sarah Jaine", :email => "sarah@jaine.com", :id => record_id)
        table.update(record)
        assert_equal "12345", record["id"]
        assert_equal "bar", record["foo"]
      end
  end # describe Airtable
end # Airtable