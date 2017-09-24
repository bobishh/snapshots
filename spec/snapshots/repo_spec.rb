require 'spec_helper'
require 'snapshots/repo'

RSpec.describe Snapshots::Repo do
  let(:options) { { db_path: 'mocked_path' } }
  let(:mocked_db) { double.as_null_object }
  let(:snapshot) { JSON.parse(File.read('spec/fixtures/payload.json'))['snapshot'] }

  subject { described_class.new(options) }

  before do
    allow(ROM).to receive(:container).and_return(mocked_db)
  end

  describe '#save!' do
    after do
      subject.save!(snapshot)
    end

    it 'calls insert on repo' do
      expect(mocked_db).to receive(:insert)
    end
  end
end
