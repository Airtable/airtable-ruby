require 'time'
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

      def new_record?
        @id.nil? || @id.empty?
      end

      def __create__(base, name)
        res = base.__make_request__(:post, name, { fields: fields })
        @id = res['id']
        parse_options(fields: res['fields'], created_at: res['createdTime'])
        self
      end

      def __update__(base, name)
        res = base.__make_request__(:patch, [name, @id].join('/'), { fields: fields })
        parse_options(fields: res['fields'])
        self
      end

      def __fetch__(base, path)
        res = base.__make_request__(:get, path, {})
        parse_options(fields: res['fields'], created_at: res['createdTime'])
        self
      end

      def __replace__(base, name)
        res = base.__make_request__(:put, [name, @id].join('/'), { fields: fields })
        parse_options(fields: res['fields'])
        self
      end

      def __destroy__(base, name)
        res = base.__make_request__(:delete, [name, @id].join('/'), {})
        res['deleted']
      end

      def [](key)
        @fields[key.to_s]
      end

      def []=(key, value)
        @fields[key.to_s] = value
      end

      class << self
        def all(base, name, params)
          res = []
          __fetch__(base, name, params, res)
          res
        end

        private

        def __fetch__(base, name, params, res)
          result = base.__make_request__(:get, name, params)
          result['records'].each do |item|
            res << new(item['id'], fields: item['fields'], created_at: item['createdTime'])
          end
          if result['offset']
            __fetch__(base, name, params.merge(offset: result['offset']), res)
          end
        end

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
