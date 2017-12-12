require 'spec_helper'

RSpec.describe ::Airtable::Client do
  context '#new' do
    context '(api_key)' do
      it 'should return proper ::Airtable::Client' do
        c = described_class.new('TEST_API')
        expect(c.instance_variable_get(:@api_key)).to eq('TEST_API')
        expect(c).to respond_to(:base)
      end
    end

    context '()' do
      it 'should return proper ::Airtable::Client' do
        allow(::ENV).to receive(:[]).with('AIRTABLE_KEY').and_return('TEST_API2')
        c = described_class.new
        expect(c.instance_variable_get(:@api_key)).to eq('TEST_API2')
        expect(c).to respond_to(:base)
      end

      it 'should raise error if no key present' do
        allow(::ENV).to receive(:[]).with('AIRTABLE_KEY').and_return(nil)
        expect { described_class.new }.to raise_error(::Airtable::MissingApiKeyError)
      end
    end
  end

  context '#base' do
    let(:client) {described_class.new}
    it 'should return ::Airtable::Base' do
      expect(client.base('TEST')).to be_a(::Airtable::Base)
    end

    it 'should have a proper data' do
      b = client.base('TEST')
      expect(b.instance_variable_get(:@id)).to eq('TEST')
      expect(b.instance_variable_get(:@client)).to eq(client)
    end
  end
end