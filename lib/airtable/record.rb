module Airtable

  class Record
    def initialize(attrs={})
      override_attributes!(attrs)
    end

    def id; @attrs["id"]; end
    def id=(val); @attrs["id"] = val; end

    # Return given attribute based on name or blank otherwise
    def [](name)
      if (name.is_a? Symbol)
        name = @key_to_name[name]
      end
      @attrs.has_key?(name) ? @attrs[name] : ""
    end

    # Set the given attribute to value
    def []=(name, value)
      if (name.is_a? Symbol)
        if @key_to_name.has_key?(name)
          name = @key_to_name[name]
        else
          # This is pretty fragile. It only works when the field name
          # is exactly the same as the symbol (to_key(name) == name).
          # In other cases, this will fail with 422 while saving to Airtable.
          @key_to_name[name] = name.to_s
          name = name.to_s
          @column_names << name
        end
      else
        if !@attrs.has_key?(name)
          @column_names << name
          @key_to_name[to_key(name)] = name
        end
      end
      @attrs[name] = value
      define_accessor_if_needed(name)
    end

    def inspect
      "#<Airtable::Record #{attributes.map { |a, v| ":#{a}=>#{v.inspect}" }.join(", ")}>"
    end

    # Hash of attributes with underscored column names
    def attributes; @attrs; end

    # Removes old and add new attributes for the record
    def override_attributes!(attrs={})
      @column_names ||= [];
      @key_to_name ||= Hash[]
      attrs.keys.each do |k|
        column_key = k.is_a?(Symbol) ? k : to_key(k)
        # k.to_s fallback is fragile
        column_name = k.is_a?(Symbol) ? @key_to_name[column_key] || k.to_s : k
        if !@key_to_name.has_key?(column_key)
          @column_names << column_name;
          @key_to_name[column_key] = column_name;
        end
      end
      @attrs = Hash[attrs.map {|k, v| [ k.is_a?(Symbol) ? @key_to_name[k] : k, v]} ]
      @attrs.map { |k, v| define_accessor_if_needed(k) }
    end

    # Hash with keys based on airtable original column names
    def fields
      Hash[@attrs]
    end

    # Airtable will complain if we pass an 'id' as part of the request body.
    def fields_for_update; fields.except('id'); end

    def method_missing(name, *args, &blk)
      # Accessor for attributes
      if args.empty? && blk.nil? && @attrs.has_key?(name)
        @attrs[name]
      else
        super
      end
    end

    def respond_to?(name, include_private = false)
      @attrs.has_key?(name) || super
    end

    protected

    def to_key(string)
      string.is_a?(Symbol) ? string : underscore(string).to_sym
    end

    def underscore(string)
      string.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        gsub(/\s/, '_').tr("-", "_").downcase
    end

    def define_accessor_if_needed(name)
      key = to_key(name)
      if !respond_to?(key)
        self.class.send(:define_method, key) { @attrs[name] }
      end
    end

  end # Record
end # Airtable
