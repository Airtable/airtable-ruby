module Airtable
  module Entity
    # Airtable Base entity
    class Base
      def initialize(id, client)
        @id     = id
        @client = client
      end

      def table(name)
        ::Airtable::Entity::Table.new(name, @id, @client)
      end
    end
  end
end
