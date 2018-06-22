require 'spec_helper'

RSpec.describe ::Airtable::Entity::Base do
  let(:client) { ::Airtable::Client.new }
  let(:base_entity) { described_class.new('appnlJrQ2fxlfRsov', client) }
  context '#table' do
    it 'should return ::Airtable::Entity::Table' do
      expect(base_entity.table('Applicants')).to be_a(::Airtable::Entity::Table)
    end
  end
end
