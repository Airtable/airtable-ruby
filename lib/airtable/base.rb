module Airtable
  class Base
    def initialize(id, client)
      @id = id
      @client = client
    end

    def table(name)
      ::Airtable::Table.new(name, @id, @client)
    end
  end
end
