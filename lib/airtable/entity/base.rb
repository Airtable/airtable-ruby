module Airtable
  module Entity
    # Airtable Base entity
    class Base
      def initialize(client, id)
        @id     = id
        @client = client
      end

      def table(name)
        ::Airtable::Entity::Table.new(self, name)
      end

      def __make_request__(method, path, data)
        url  = [::Airtable.server_url, @id, path].join('/')
        resp = ::Airtable::Request.new(url, data, @client.api_key)
                                  .request(method)
        if resp.success?
          resp.result
        else
          raise_correct_error_for(resp)
        end
      end

      # rubocop:disable all
      def raise_correct_error_for(resp)
        case resp.raw.code.to_i
        when 401
          raise Airtable::AuthRequiredError.new(resp.raw)
        when 403
          raise ::Airtable::NotAuthorizedError.new(resp.raw)
        when 404
          raise ::Airtable::NotFoundError.new(resp.raw)
        when 413
          raise ::Airtable::RequestBodyTooLargeError.new(resp.raw)
        when 422
          raise ::Airtable::UnprocessableEntityError.new(resp.raw)
        when 429
          raise ::Airtable::TooManyRequestsError.new(resp.raw)
        when 500
          raise ::Airtable::ServerError.new(resp.raw)
        when 503
          raise ::Airtable::ServiceUnavailableError.new(resp.raw)
        else
          if resp.raw.code.to_i > 400
            raise ::Airtable::RequestError.new(resp.raw, 'An unexpected error occurred')
          end
        end
        # rubocop:enable all
      end
    end
  end
end
