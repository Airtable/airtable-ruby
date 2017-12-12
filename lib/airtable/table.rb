module Airtable
  class Table
    PAGE_SIZE         = 100.freeze
    DEFAULT_DIRECTION = 'asc'.freeze

    def initialize(name, base_id, client)
      @name    = name
      @base_id = base_id
      @client  = client
    end

    def records(options = {})
      params              = {}
      params[:fields]     = option_value_for(options, :fields)
      params[:maxRecords] = option_value_for(options, :max_records)
      params[:pageSize]   = option_value_for(options, :limit) || PAGE_SIZE
      update_sort_options(params, options)
    end

    def option_value_for(hash, key)
      hash.delete(key) || hash.delete(key.to_s)
    end

    def update_sort_options(params, options)
      sort_option = option_value_for(options, :sort)
      case sort_option
      when ::Array
        raise ::Airtable::SortOptionsError if sort_option.size == 0
      when ::Hash
        add_hash_sort_option(params, sort_option)
      when ::String
        add_string_sort_option(params, sort_option)
      end
    end

    def add_string_sort_options(params, string)
      raise ::Airtable::SortOptionsError if string.nil? || string.empty?
      params[:sort] ||= []
      params[:sort] << { field: string, direction: DEFAULT_DIRECTION }
    end

    def add_hash_sort_option(params, hash)
      raise ::Airtable::SortOptionsError if hash.keys.map(&:to_sym).sort == [:direction, :field]
      params[:sort] ||= []
      params[:sort] << hash
    end

    def add_sort_options(params, sort_option)
      case sort_option
      when ::Array
        if sort_option.size == 2
          params[:sort] ||= []
          params[:sort] << { field: sort_option[0], direction: sort_option[1] }
        else
          raise ::Airtable::SortOptionsError.new
        end
      when ::Hash
      when ::String

      end
    end
  end
end
