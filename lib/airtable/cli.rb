require 'optparse'
require 'airtable'

# rubocop:disable all
module Airtable
  # Command line Class
  class CLI
    def initialize(args)
      trap_interrupt
      @operation = args.shift
      @args    = args
      @options = {}
      @parser  = OptionParser.new
    end

    def start
      add_banner
      add_options
      add_tail_options
      add_supported_operations
      @parser.parse!(@args)
      if @options.empty?
        puts @parser
      else
        unless valid_options?
          puts @parser
          return
        end
        run_operation
      end
    end

    def add_banner
      @parser.banner = 'Usage: airtable operation options'
      @parser.separator ''
    end

    def add_options
      @parser.separator 'Common options:'
      @parser.on('-kKEY', '--api_key=KEY', 'Airtable API key') do |key|
        @options[:api_key] = key
      end
      @parser.on('-tNAME', '--table NAME', 'Table Name') do |table|
        @options[:table_name] = table
      end
      @parser.on('-bBASE_ID', '--base BASE_ID', 'Base ID') do |base_id|
        @options[:base_id] = base_id
      end
      @parser.on('-rRECORD_ID', '--record RECORD_ID', 'Record ID') do |record_id|
        @options[:record_id] = record_id
      end
      @parser.on('-fFIELD_NAME', '--field FIELD_NAME', 'Field name to update or read') do |field_name|
        @options[:field_name] = field_name
      end
      @parser.on('-vVALUE', '--value VALUE', 'Field value for update') do |field_value|
        @options[:field_value] = field_value
      end
    end

    def add_tail_options
      @parser.on_tail('-h', '--help', 'Show this message') do
        puts @parser
        exit
      end
      @parser.on_tail('--version', 'Show version') do
        puts ::Airtable::VERSION
        exit
      end
    end

    def add_supported_operations
      @parser.separator ''
      @parser.separator 'Supported Operations:'
      @parser.separator "\tget - Get Record/Field"
      @parser.separator "\tupdate - Update Field"
      @parser.separator ''
      @parser.separator 'Examples:'
      @parser.separator "\tairtable get -B Base -t Table"
      @parser.separator "\tairtable get -B Base -t Table -r RECORD_ID"
      @parser.separator "\tairtable get -B Base -t Table -f FIELD_NAME"
      @parser.separator "\tairtable get -B Base -t Table -f FIELD_NAME -r RECORD_ID"
      @parser.separator "\tairtable update -b Base -t table -r RECORD_ID -f FIELD_NAME -v newValue"
      @parser.separator ''
    end

    def valid_options?
      @options[:table_name] && !@options[:table_name].empty? &&
        @options[:base_id] && !@options[:base_id].empty?
    end

    def record_id?
      @options[:record_id] && !@options[:record_id].empty?
    end

    def field_name?
      @options[:field_name] && !@options[:field_name].empty?
    end

    def run_operation
      case @operation
      when "get"
        case
        when record_id? && field_name?
          print_field  
        when record_id? && !field_name?
          print_record
        when !record_id? && field_name?
          print_fields
        else
          print_records
        end
      when "update"
        [:field_value, :field_name, :record_id].each do |key|
          return if !@options[key] || @options[key].empty?
        end
        update_field
      end
    end
    
    def print_records
      puts (::Airtable::Client.new(@options[:api_key]).base(@options[:base_id]).table(@options[:table_name]).select.map do |record|
        { id: record.id, fields: record.fields, createdTime: record.created_at }
      end).to_json
    end

    def print_record
      record = ::Airtable::Client.new(@options[:api_key]).base(@options[:base_id]).table(@options[:table_name]).find(@options[:record_id])
      puts ({ id: record.id, fields: record.fields, createdTime: record.created_at }).to_json
    end

    def print_field
      record = ::Airtable::Client.new(@options[:api_key]).base(@options[:base_id]).table(@options[:table_name]).find(@options[:record_id])
      puts record.fields[@options[:field_name]]
    end

    def print_fields
      ::Airtable::Client.new(@options[:api_key]).base(@options[:base_id]).table(@options[:table_name]).select.each do |record|
        puts record.fields[@options[:field_name]]
      end
    end

    def update_field
      ::Airtable::Client.new(@options[:api_key]).base(@options[:base_id]).table(@options[:table_name])
                        .update(@options[:record_id], @options[:field_name] => @options[:field_value])
      record = ::Airtable::Client.new(@options[:api_key]).base(@options[:base_id]).table(@options[:table_name]).find(@options[:record_id])
      if record.fields[@options[:field_name]] == @options[:field_value]
        puts 'OK'
      else
        puts 'ERROR'
      end
    end

    def trap_interrupt
      trap('INT') { exit!(1) }
    end
  end
end
# rubocop:enable all
