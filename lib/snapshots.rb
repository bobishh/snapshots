require 'sinatra/base'
require 'snapshots/store'
require 'snapshots/pusher'
require 'snapshots/settings'
require 'snapshots/repo'
require 'bunny'
require 'json'
require 'rom-sql'

module Snapshots
  # application class
  class App < ::Sinatra::Base
    set :port, 4242
    set :bind, '0.0.0.0'
    set :raise_errors, true
    set :dump_errors, false
    set :show_exceptions, false
    set :json_encoder, :to_json

    helpers do
      def config
        ::Snapshots::Settings
      end

      def repo
        @repo ||= begin
                    db = ROM.container(:sql, config.db_path)
                    ::Snapshots::Repo.new(db)
                  end
      end

      def store
        @store ||= ::Snapshots::Store.new(storage_path: config.storage_path)
      end

      def pusher
        @pusher ||= ::Snapshots::Pusher.new(bus_path: config.bus_path,
                                            adapter: Bunny)
      end
    end

    get '/robots.txt' do
      ''
    end

    get '/snapshots/:camera_id' do
      shots = repo.query(camera_id: params['camera_id']).call&.to_a&.map { |i| i.to_json }
      status 200
      shots
    end

    post '/snapshots' do
      params_string = request.body.read
      params = JSON.parse(params_string)
      snapshot = params['snapshot']
      res = store.save!(snapshot) do |filepath|
        pusher.notify!(filepath, snapshot['camera_id'])
        repo.save!(snapshot.merge('filepath' => filepath))
      end
      status 201
      { snapshot: { id: res.id } }.to_json
    end
  end
end
