module Airtable
  module Entity
    # Airtable Table entity
    class Table
      PAGE_SIZE         = 100
      DEFAULT_DIRECTION = 'asc'.freeze

      def initialize(base, name)
        @name = name
        @base = base
        @args = [@base, @name]
      end

      def select(options = {})
        params = {}
        update_default_params(params, options)
        update_sort_options(params, options)
        validate_params(params)
        fetch_records(params.compact)
      end

      def find(id)
        args = [@base, [@name, id].join('/')]
        ::Airtable::Entity::Record.new(id).__fetch__(*args)
      end

      def create(fields)
        ::Airtable::Entity::Record.new(nil, fields: fields).__create__(*@args)
      end

      def update(id, fields)
        ::Airtable::Entity::Record.new(id, fields: fields).__update__(*@args)
      end

      def replace(id, fields)
        ::Airtable::Entity::Record.new(id, fields: fields).__replace__(*@args)
      end

      def destroy(id)
        ::Airtable::Entity::Record.new(id).__destroy__(*@args)
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
        if params[:fields] && !params[:fields].is_a?(::Array)
          raise ::Airtable::FieldsOptionError
        end
        raise ::Airtable::LimitOptionError if params[:pageSize].to_i <= 0
        if params[:maxRecords] && params[:maxRecords].to_i <= 0
          raise ::Airtable::MaxRecordsOptionError
        end
      end

      def update_sort_options(params, options)
        sort_option = option_value_for(options, :sort)
        case sort_option
        when ::Array
          add_array_sort_options(params, sort_option)
        when ::Hash
          add_hash_sort_option(params, sort_option)
        when ::String
          add_string_sort_option(params, sort_option)
        end
      end

      def add_array_sort_options(params, array)
        raise ::Airtable::SortOptionError if array.empty?
        if array.size == 2
          add_sort_options(params, array)
        else
          array.each do |item|
            add_sort_options(params, item)
          end
        end
      end

      def add_string_sort_option(params, string)
        raise ::Airtable::SortOptionError if string.nil? || string.empty?
        params[:sort] ||= []
        params[:sort] << { field: string, direction: DEFAULT_DIRECTION }
      end

      def add_hash_sort_option(params, hash)
        if hash.keys.map(&:to_sym).sort != %i[direction field]
          raise ::Airtable::SortOptionError
        end
        params[:sort] ||= []
        params[:sort] << hash
      end

      def add_sort_options(params, sort_option)
        case sort_option
        when ::Array
          raise Airtable::SortOptionError if sort_option.size != 2
          params[:sort] ||= []
          params[:sort] << { field: sort_option[0], direction: sort_option[1] }
        when ::Hash
          add_hash_sort_option(params, sort_option)
        else
          raise Airtable::SortOptionError
        end
      end
    end
  end
end
