require 'time'
# Main object for store Airtable Record entity
module Airtable
  module Entity
    # Airtable Record entity
    class Record
      extend Forwardable
      attr_reader :id, :created_at, :fields

      def initialize(id, options = {})
        @id = id
        parse_options(options)
      end

      def new_record?
        @id.nil? || @id.empty?
      end

      def __create__(base, table_name)
        res = base.__make_request__(:post, table_name, fields: fields)
        @id = res['id']
        parse_options(fields: res['fields'], created_at: res['createdTime'])
        self
      end

      def __update__(base, table_name)
        args = [:patch, [table_name, @id].join('/'), fields: fields]
        res  = base.__make_request__(*args)
        parse_options(fields: res['fields'])
        self
      end

      def __fetch__(base, path)
        res = base.__make_request__(:get, path, {})
        parse_options(fields: res['fields'], created_at: res['createdTime'])
        self
      end

      def __replace__(base, table_name)
        res = base.__make_request__(:put, [table_name, @id].join('/'), fields: fields)
        parse_options(fields: res['fields'])
        self
      end

      def __destroy__(base, table_name)
        res = base.__make_request__(:delete, [table_name, @id].join('/'), {})
        res['deleted']
      end

      def [](key)
        @fields[key.to_s]
      end

      def []=(key, value)
        @fields[key.to_s] = value
      end

      class << self
        def all(base, table_name, params)
          res = []
          __fetch__(base, table_name, params, res)
          res
        end

        private

        def __fetch__(base, table_name, params, res)
          result = base.__make_request__(:get, table_name, params)
          result['records'].each do |r|
            args = [
              r['id'], fields: r['fields'], created_at: r['createdTime']
            ]
            res << new(*args)
          end
          return unless result['offset']
          __fetch__(base, table_name, params.merge(offset: result['offset']), res)
        end
      end

      private

      def parse_options(options = {})
        if (fields = options.delete(:fields)) && !fields.empty?
          @fields = fields
        end
        created_at = options.delete(:created_at)
        return unless created_at
        @created_at = ::Time.parse(created_at)
      end
    end
  end
end
