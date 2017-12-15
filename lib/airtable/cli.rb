require 'optparse'
require 'airtable'

# * Build a command-line tool to allow simple command-line interactions:
# Interactions:
#   * retrieve record JSON by record ID and table ID
#   * retrieve all values for a single field ID or name from a table (allow adding viewId and filterByFormula)
#   * update single record field

module Airtable
  class CLI
    class << self
      SUPPORTED_OPERATIONS = [
        "record",
        "values",
        "update_record_field"
      ]

      def start
        run(ARGV, $stderr, $stdout)
      end

      def run(args, err=$stderr, out=$stdout)
        trap_interrupt
        options = {}
        OptionParser.new do |parser|
          parser.banner = "Usage: airtable [options]"
          parser.separator ""
          parser.separator "Common options:"
          parser.on("-kKEY", "--api_key=KEY", "Airtable API key") do |key|
            options[:api_key] = key
          end
          parser.on("-oOPERATION", "--operation OPERATION", "Operation what need to make") do |operation|
            options[:operation] = operation
          end
          parser.on("-tNAME", "--table NAME", "Table Name") do |table|
            options[:table_name] = table
          end
          parser.on("-bBASE_ID", "--base BASE_ID", "Base ID") do |base_id|
            options[:base_id] = base_id
          end
          parser.on("-rRECORD_ID", "--record RECORD_ID", "Record ID") do |record_id|
            options[:record_id] = record_id
          end
          parser.on_tail("-h", "--help", "Show this message") do
            puts parser
            exit
          end
          parser.on_tail("--version", "Show version") do
            puts ::Airtable::Version
            exit
          end
          parser.separator ""
          parser.separator "Supported Operations"
          SUPPORTED_OPERATIONS.each do |operation|
            parser.separator "\t* #{operation}"
          end
          parser.separator ""
          parser.parse!(args)
          if options.empty?
            puts parser
          else
            case options.delete(:operation)
            when "record"
              print_record(options)
            else
              puts parser
            end
          end
        end
      end

      def print_record(options)
        record = ::Airtable::Client.new(options[:api_key]).base(options[:base_id]).table(options[:table_name]).find(options[:record_id])
        puts ({:id => record.id, :fields => record.fields, createdTime: record.created_at}).to_json
      end

      def trap_interrupt
        trap('INT') {exit!(1)}
      end
    end
  end
end