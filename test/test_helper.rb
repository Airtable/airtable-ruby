require 'airtable'
require 'fakeweb'
require 'minitest/pride'
require 'minitest/autorun'
require 'active_support/core_ext/hash'

# https://github.com/chrisk/fakeweb
FakeWeb.allow_net_connect = false

def stub_airtable_response!(url, response, method=:get)
  FakeWeb.register_uri(method, url, :body => response.to_json, :content_type => "application/json")
end