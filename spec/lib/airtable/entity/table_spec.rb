require 'spec_helper'
require 'pry'

RSpec.describe ::Airtable::Entity::Table, vcr: true do
  let(:client) {::Airtable::Client.new}
  let(:base_id) {'appnlJrQ2fxlfRsov'}
  let(:base) {::Airtable::Entity::Base.new(client, base_id) }
  let(:table_entity) {described_class.new(base, 'Applicants')}
  context '#select' do
    context '()' do
      it 'should return array of ::Airtable::Entity::Record' do
        res = table_entity.select
        expect(res).to be_a(::Array)
        expect(res.map(&:class).uniq).to eq([::Airtable::Entity::Record])
      end
      it 'should return proper ::Airtable::Entity::Record' do
        record = table_entity.select[0]
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
        expect(table_entity.select(max_records: 2).size).to eq(2)
      end
    end

    context '({limit: 2})' do
      it 'should return all records records' do
        expect(table_entity.select(limit: 2).size).to eq(3)
      end
    end

    context '({sort: "Name", max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: described_class::DEFAULT_DIRECTION }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params).and_call_original
        expect {table_entity.select(sort: 'Name', max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: ["Name", "desc"], max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params).and_call_original
        expect {table_entity.select(sort: ['Name', 'desc'], max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: [["Name", "desc"]], max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params).and_call_original
        expect {table_entity.select(sort: [['Name', 'desc']], max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: [{field: "Name", direction: "desc"}], max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params).and_call_original
        expect {table_entity.select(sort: [{ field: 'Name', direction: 'desc' }], max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: {field: "Name", direction: "desc"}, max_records: 2})' do
      it 'should sort records by Name' do
        params = {
          pageSize:   described_class::PAGE_SIZE,
          sort:       [{ field: 'Name', direction: 'desc' }],
          maxRecords: 2
        }
        expect(table_entity).to receive(:fetch_records).with(params).and_call_original
        expect {table_entity.select(sort: { field: 'Name', direction: 'desc' }, max_records: 2)}.to_not raise_error
      end
    end

    context '({sort: ["Name", "desc", "other"]})' do
      it 'should raise ::Airtable::SortOptionsError' do
        expect { table_entity.select(sort: ["Name", "desc", "other"]) }.to raise_error(::Airtable::SortOptionsError)
      end
    end

    context '({sort: {feild: "Name", direction: "desc"}})' do
      it 'should raise ::Airtable::SortOptionsError' do
        expect { table_entity.select(sort: {feild: "Name", direction: "desc"}) }.to raise_error(::Airtable::SortOptionsError)
      end
    end

  end
  context '#find' do
    it 'should return a one record' do
      record = table_entity.find('recQes7d2DCuEcGe0')
      expect(record).to be_a(::Airtable::Entity::Record)
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

  context '#create' do
    it 'should create new record' do

      fields = {
        'Name' => 'Super Test Name'
      }
      record = table_entity.create(fields)
      expect(record).to be_a(::Airtable::Entity::Record)
      expect(record.id).to_not be_nil
      expect(record.created_at).to be_a(::Time)
      expect(record.fields).to be_a(::Hash)
      expect(record['Name']).to eq(fields['Name'])
      rec = table_entity.find(record.id)
      expect(rec['Name']).to eq(record['Name'])
    end
  end

  context '#update' do
    it 'should update record' do
      id = 'recIsbIqSnj72dp0O'
      fields = {
        'Name' => 'Super Dupper Name'
      }
      record = table_entity.update(id, fields)
      expect(record['Name']).to eq(fields['Name'])
      rec = table_entity.find(id)
      expect(rec['Name']).to eq(record['Name'])
    end
  end

  context '#replace' do
    it 'should replace record' do
      id = 'recSIn39bSTqt4Swc'
      fields = {
        'Name' => 'Super Dupper Pupper Name'
      }
      expect(table_entity.find(id)['Phone']).to eq('(646) 555-4389')
      record = table_entity.replace(id, fields)
      expect(record['Name']).to eq(fields['Name'])
      rec = table_entity.find(id)
      expect(rec['Name']).to eq(record['Name'])
      expect(rec['Phone']).to be_nil
    end
  end

  context '#destroy' do
    it 'should remove record' do
      id = 'recOjo2sDyUYHNSEH'
      expect(table_entity.destroy(id)).to be_truthy
    end
  end

end
