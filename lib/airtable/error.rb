module Airtable
  class SortOptionsError < ::ArgumentError
    def initialize
      super('Unknown sort option format.')
    end
  end

  class MissingApiKeyError < ::ArgumentError
    def initialize
      super('Missing API key')
    end
  end

  class FieldsOptionsError < ::ArgumentError
    def initialize
      super('Invalid fields option format.')
    end
  end

  class LimitOptionsError < ::ArgumentError
    def initialize
      super('Invalid limit option format.')
    end
  end

  class MaxRecordsOptionsError < ::ArgumentError
    def initialize
      super('Invalid max_records option format.')
    end
  end
end
