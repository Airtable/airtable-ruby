# Main object for store Airtable Record entity
module Airtable
  module Entity
    class Record
      extend Forwardable
      attr_reader :id, :created_at, :fields

      def_delegators :@fields, :[], :[]=

      def initialize(id, options = {})
        @id = id
        parse_options(options)
      end

      def [](key)
        @fields[key.to_s]
      end

      def []=(key, value)
        @fields[key.to_s] = value
      end

      private

      def parse_options(options = {})
        if (fields = options.delete(:fields)) && !fields.empty?
          @fields = fields
        end
        if (created_at = options.delete(:created_at))
          @created_at = ::Time.parse(created_at)
        end
      end

    end
  end
end
