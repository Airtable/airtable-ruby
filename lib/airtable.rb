require 'logger'

module Airtable
  class << self
    DEFAULT_URL = 'https://api.airtable.com/v0'.freeze
    attr_writer :log_path

    def debug?
      !ENV['DEBUG'].nil?
    end

    def log_path
      @log_path ||= 'airtable.log'
    end

    def logger
      @logger ||= ::Logger.new(@log_path)
    end

    def server_url
      @server_url ||= ENV.fetch('AIRTABLE_ENDPOINT_URL') { DEFAULT_URL }
    end

    def reset!
      @log_path = nil
      @logger = nil
      @server_url = nil
    end
  end
end

require 'airtable/base'
require 'airtable/client'
require 'airtable/table'
require 'airtable/error'


#require 'airtable/resource'
#require 'airtable/record'
#require 'airtable/record_set'
