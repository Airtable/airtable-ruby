module Airtable
  module Entity
    # Airtable Table entity
    class Table
      PAGE_SIZE         = 100
      DEFAULT_DIRECTION = 'asc'.freeze

      def initialize(base, name)
        @name = name
        @base = base
      end

      def select(options = {})
        params = {}
        update_default_params(params, options)
        update_sort_options(params, options)
        validate_params(params)
        fetch_records(params.compact)
      end

      def find(id)
        ::Airtable::Entity::Record.new(id).__fetch__(@base, [@name, id].join('/'))
      end

      def create(fields)
        ::Airtable::Entity::Record.new(nil, fields: fields).__create__(@base, @name)
      end

      def update(id, fields)
        ::Airtable::Entity::Record.new(id, fields: fields).__update__(@base, @name)
      end

      def replace(id, fields)
        ::Airtable::Entity::Record.new(id, fields: fields).__replace__(@base, @name)
      end

      def destroy(id)
        ::Airtable::Entity::Record.new(id).__destroy__(@base, @name)
      end

      private

      def option_value_for(hash, key)
        hash.delete(key) || hash.delete(key.to_s)
      end

      def fetch_records(params)
        ::Airtable::Entity::Record.all(@base, @name, params)
      end

      def update_default_params(params, options)
        params[:fields]     = option_value_for(options, :fields)
        params[:maxRecords] = option_value_for(options, :max_records)
        params[:offset]     = option_value_for(options, :offset)
        params[:pageSize]   = option_value_for(options, :limit) || PAGE_SIZE
      end

      def validate_params(params)
        raise ::Airtable::FieldsOptionsError if params[:fields] && !params[:fields].is_a?(::Array)
        raise ::Airtable::LimitOptionsError if params[:pageSize] && !(params[:pageSize].to_i > 0)
        raise ::Airtable::MaxRecordsOptionsError if params[:maxRecords] && !(params[:maxRecords].to_i > 0)
      end

      def update_sort_options(params, options)
        sort_option = option_value_for(options, :sort)
        case sort_option
        when ::Array
          raise ::Airtable::SortOptionsError if sort_option.empty?
          if sort_option.size == 2
            add_sort_options(params, sort_option)
          else
            sort_option.each do |item|
              add_sort_options(params, item)
            end
          end
        when ::Hash
          add_hash_sort_option(params, sort_option)
        when ::String
          add_string_sort_option(params, sort_option)
        end
      end

      def add_string_sort_option(params, string)
        raise ::Airtable::SortOptionsError if string.nil? || string.empty?
        params[:sort] ||= []
        params[:sort] << { field: string, direction: DEFAULT_DIRECTION }
      end

      def add_hash_sort_option(params, hash)
        raise ::Airtable::SortOptionsError if hash.keys.map(&:to_sym).sort != %i[direction field]
        params[:sort] ||= []
        params[:sort] << hash
      end

      def add_sort_options(params, sort_option)
        case sort_option
        when ::Array
          raise Airtable::SortOptionsError if sort_option.size != 2
          params[:sort] ||= []
          params[:sort] << { field: sort_option[0], direction: sort_option[1] }
        when ::Hash
          add_hash_sort_option(params, sort_option)
        else
          raise Airtable::SortOptionsError
        end
      end
    end
  end
end
