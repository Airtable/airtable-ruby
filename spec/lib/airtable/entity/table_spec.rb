require 'spec_helper'
require 'pry'

RSpec.describe ::Airtable::Entity::Table, vcr: true do
  let(:client) { ::Airtable::Client.new }
  let(:base_id) { 'appnlJrQ2fxlfRsov' }
  let(:table_entity) { described_class.new('Applicants', base_id, client) }
  context '#records' do
    context '()' do
      it 'should return array of ::Airtable::Entity::Record' do
        res = table_entity.records
        expect(res).to be_a(::Array)
      end
    end
  end
end
