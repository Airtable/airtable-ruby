# Main object for store Airtable Record entity
module Airtable
  module Entity
    class Record
      attr_reader :id, :created_at, :fields

      def initialize(id, options = {})
        @id = id
        parse_options(options)
      end

      def parse_options(options = {})
        if (fields = options.delete(:fields)) && !fields.empty?
          @fields = fields
        end
        if (created_at = options.delete(:created_at))
          @created_at = created_at
        end
      end
    end
  end
end
