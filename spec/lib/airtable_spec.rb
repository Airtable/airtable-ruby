require 'spec_helper'

RSpec.describe ::Airtable do
  context '#server_url' do
    before :each do
      described_class.reset!
    end
    it 'should return default' do
      expect(described_class.server_url).to eq('https://api.airtable.com/v0')
    end

    it 'should custom from ENV' do
      allow(ENV).to receive(:fetch).with('AIRTABLE_ENDPOINT_URL').and_return('CUSTOM')
      expect(described_class.server_url).to eq('CUSTOM')
    end
  end

  context '#log_path' do
    it 'should return default path' do
      expect(described_class.log_path).to eq('airtable.log')
    end

    it 'should return a custom' do
      described_class.log_path = 'another.log'
      expect(described_class.log_path).to eq('another.log')
    end
  end

  context '#debug?' do
    it 'should return false' do
      expect(described_class.debug?).to be_falsey
    end

    it 'should return true' do
      allow(ENV).to receive(:[]).with('DEBUG').and_return('1')
      expect(described_class.debug?).to be_truthy
    end
  end

  context '#logger' do
    it 'should return logger object' do
      expect(described_class.logger).to be_a(::Logger)
    end
  end
end
