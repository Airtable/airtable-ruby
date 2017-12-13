require 'spec_helper'
require 'pry'

RSpec.describe ::Airtable::Entity::Table, vcr: true do
  let(:client) {::Airtable::Client.new}
  let(:base_id) {'appnlJrQ2fxlfRsov'}
  let(:table_entity) {described_class.new('Applicants', base_id, client)}
  context '#records' do
    context '()' do
      it 'should return array of ::Airtable::Entity::Record' do
        res = table_entity.records
        expect(res).to be_a(::Array)
        expect(res.map(&:class).uniq).to eq([::Airtable::Entity::Record])
      end
      it 'should return proper ::Airtable::Entity::Record' do
        record = table_entity.records[0]
        expect(record.id).to eq('recQes7d2DCuEcGe0')
        expect(record.created_at).to be_a(::Time)
        expect(record.created_at).to eq(::Time.parse('2015-11-11T23:05:58.000Z'))
        expect(record.fields).to be_a(::Hash)
        expect(record).to respond_to(:[])
        expect(record).to respond_to(:[]=)
        expect(record['Name']).to eq('Chippy the Potato')
        expect(record[:Name]).to eq('Chippy the Potato')
      end
    end

    context '({max_records:2})' do
      it 'should return only 2 records' do
        expect(table_entity.records(max_records: 2).size).to eq(2)
      end
    end

    context '({limit: 2})' do
      it 'should return all records records' do
        expect(table_entity.records(limit: 2).size).to eq(3)
      end
    end

    context '({sort: "Name", max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: described_class::DEFAULT_DIRECTION }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params, []).and_call_original
        expect {table_entity.records(sort: 'Name', max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: ["Name", "desc"], max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params, []).and_call_original
        expect {table_entity.records(sort: ['Name', 'desc'], max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: [["Name", "desc"]], max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params, []).and_call_original
        expect {table_entity.records(sort: [['Name', 'desc']], max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: [{field: "Name", direction: "desc"}], max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params, []).and_call_original
        expect {table_entity.records(sort: [{ field: 'Name', direction: 'desc' }], max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: {field: "Name", direction: "desc"}, max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params, []).and_call_original
        expect {table_entity.records(sort: { field: 'Name', direction: 'desc' }, max_records: 2)}.to_not raise_error
      end
    end

  end
end
