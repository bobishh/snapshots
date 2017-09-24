require 'spec_helper'
require 'bunny'
require 'snapshots/pusher'

RSpec.describe Snapshots::Pusher do
  let(:adapter_mock) { class_double(Bunny) }
  let(:bunny_mock) { double.as_null_object }
  let(:camera_id) { 42 }
  let(:filepath) { 'snapshot_1.jpg' }

  let(:options) do
    { bus_path: 'localhost:5672',
      adapter: adapter_mock }
  end

  before do
    allow(adapter_mock).to receive(:new)
                             .with(options[:bus_path])
                             .and_return(bunny_mock)
    allow(bunny_mock).to receive(:start)
  end

  subject { described_class.new(options) }
  describe '#notify!' do
    let(:channel_instance) { double.as_null_object }
    let(:exchange_instance) { double.as_null_object }

    before do
      allow(bunny_mock).to receive(:create_channel).and_return(channel_instance)
      allow(channel_instance)
        .to receive(:topic)
        .and_return(exchange_instance)
    end

    after do
      subject.notify!(filepath, camera_id)
    end

    it 'uses bus_path when initializing conection' do
      expect(adapter_mock).to receive(:new).with(options[:bus_path])
    end

    it 'calls start on connection' do
      expect(bunny_mock).to receive(:start)
    end

    it 'creates channel for camera' do
      expect(bunny_mock).to receive(:create_channel)
    end

    it 'creates topic' do
      expect(channel_instance).to receive(:topic).with('snapshots')
    end

    it 'puts message to rabbitmq' do
      expect(exchange_instance).to receive(:publish).with(filepath, routing_key: camera_id)
    end
  end
end
