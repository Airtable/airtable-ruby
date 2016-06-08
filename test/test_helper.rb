require 'airtable'
require 'webmock/minitest'
require 'minitest/pride'
require 'minitest/autorun'

def stub_airtable_response!(url, response, method=:get, status=200)
  stub_request(method, url)
    .to_return(
      body: response.to_json,
      status: status,
      headers: { 'Content-Type' => 'application/json' }
    )
end
