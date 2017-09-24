require 'spec_helper'
require 'snapshots/store'
require 'json'

RSpec.describe Snapshots::Store do
  subject { described_class.new(storage_path: storage_path) }

  describe '#save!' do
    let(:snapshot) { JSON.parse(File.read('spec/fixtures/payload.json'))['snapshot'] }
    let(:camera_id) { snapshot['camera_id'] }
    let(:storage_path) { 'uploads' }
    let(:timestamp) { Time.now.strftime('%Y%m%d_%H%M') }
    let(:expected_path) { "#{storage_path}/#{camera_id}/snapshot_#{timestamp}.jpg" }

    let(:mocked_file) { instance_double(File).as_null_object }

    before do
      allow(File).to receive(:open).and_return(mocked_file)
    end

    it 'returns filename' do
      expect(subject.save!(snapshot)).to eq(expected_path)
    end

    it 'lets yield with passed filename' do
      expect(subject.save!(snapshot) { |p| "+#{p}" }).to eq("+#{expected_path}")
    end

    context 'file operations' do
      after do
        subject.save!(snapshot)
      end

      it 'opens file with expected path and permissions' do
        expect(File).to receive(:open).with(expected_path, 'w+')
      end

      it 'writes received file to disk' do
        expect(mocked_file).to receive(:write)
      end
    end
  end
end
