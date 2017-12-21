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

  # Request error
  class RequestError < StandardError
    attr_reader :body

    def initialize(body, message)
      @body = body
      super(message)
    end
  end

  # auth error
  class AuthRequiredError < ::Airtable::RequestError
    def initialize(body)
      super(body, 'You should provide valid api key to perform this operation')
    end
  end

  # not authorized
  class NotAuthorizedError < ::Airtable::RequestError
    def initialize(body)
      super(body, 'You are not authorized to perform this operation')
    end
  end

  # not found error
  class NotFoundError < ::Airtable::RequestError
    def initialize(body)
      super(body, 'Could not find what you are looking for')
    end
  end

  # request body too large
  class RequestBodyTooLargeError < ::Airtable::RequestError
    def initialize(body)
      super(body, 'Request body is too large')
    end
  end

  # unprocessed error
  class UnprocessableEntityError < ::Airtable::RequestError
    def initialize(body)
      super(body, 'The operation cannot be processed')
    end
  end

  # too many requests
  class TooManyRequestsError < ::Airtable::RequestError
    def initialize(body)
      # rubocop:disable Metrics/LineLength
      super(body, 'You have made too many requests in a short period of time. Please retry your request later')
      # rubocop:enable Metrics/LineLength
    end
  end

  # server error
  class ServerError < ::Airtable::RequestError
    def initialize(body)
      super(body, 'Try again. If the problem persists, contact support.')
    end
  end

  # service unavailable
  class ServiceUnavailableError < ::Airtable::RequestError
    def initialize(body)
      # rubocop:disable Metrics/LineLength
      super(body, 'The service is temporarily unavailable. Please retry shortly.')
      # rubocop:enable Metrics/LineLength
    end
  end
end
