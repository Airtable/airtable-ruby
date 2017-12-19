module Airtable
  # missing api key error
  class MissingApiKeyError < ::ArgumentError
    def initialize
      super('Missing API key')
    end
  end

  # sort option key error
  class SortOptionError < ::ArgumentError
    def initialize
      super('Unknown sort option format.')
    end
  end

  # fields option key error
  class FieldsOptionError < ::ArgumentError
    def initialize
      super('Invalid fields option format.')
    end
  end
  # limit option key error
  class LimitOptionError < ::ArgumentError
    def initialize
      super('Invalid limit option format.')
    end
  end

  # max records option key error
  class MaxRecordsOptionError < ::ArgumentError
    def initialize
      super('Invalid max_records option format.')
    end
  end
end
