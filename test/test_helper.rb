require 'airtable'
require 'fakeweb'
require 'minitest/pride'
require 'minitest/autorun'

# https://github.com/chrisk/fakeweb
FakeWeb.allow_net_connect = false

def stub_airtable_response(url, response)
  FakeWeb.register_uri(:get, url, :body => response.to_json, :content_type => "application/json")
end