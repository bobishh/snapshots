require 'rom-repository'
require 'rom-sql'

class ROM::Struct::Snapshot < ROM::Struct
  def to_json
    to_hash.to_json
  end
end

module Snapshots
  # stores received snapshot in db
  class Repo < ::ROM::Repository[:snapshots]
    commands :create, :where

    def query(conditions)
      snapshots.where(conditions)
    end

    def save!(snapshot)
      create(process(snapshot))
    end

    private

    def process(snapshot)
      { received: Time.now.to_datetime,
        camera_id: snapshot['camera_id'],
        path: snapshot['filepath'],
        state: 'received',
        taken: Time.parse(snapshot['taken']) }
    end
  end
end
