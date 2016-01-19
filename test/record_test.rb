require 'test_helper'

describe Airtable do
  describe Airtable::Record do
    it "should not return id in fields_for_update" do
      record = Airtable::Record.new(:name => "Sarah Jaine", :email => "sarah@jaine.com", :id => 12345)
      record.fields_for_update.wont_include(:id)
    end

    it "returns new columns in fields_for_update" do
      record = Airtable::Record.new(:name => "Sarah Jaine", :email => "sarah@jaine.com", :id => 12345)
      record[:website] = "http://sarahjaine.com"
      record.fields_for_update.must_include(:website)
    end

    it "returns fields_for_update in original capitalization" do
      record = Airtable::Record.new("Name" => "Sarah Jaine")
      record.fields_for_update.must_include("Name")
    end
  end # describe Record
end # Airtable
