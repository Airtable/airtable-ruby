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

      def raise_correct_error_for(resp); end
    end
  end
end
