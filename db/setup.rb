require 'rom-sql'
require_relative '../lib/snapshots/settings'
module DB
  module Setup
    def self.run!
      rom = ROM.container(:sql, ::Snapshots::Settings.db_path)

      gateway = rom.gateways[:default]

      migration = gateway.migration do
        change do
          create_table :snapshots do
            primary_key :id
            column :camera_id, Integer, null: false
            column :path, String, null: false
            column :state, String, null: false, default: 'germ'
            column :taken, DateTime, null: false
            column :received, DateTime, null: false
          end
        end
      end

      migration.apply(gateway.connection, :up)
      puts "[#{Time.now.strftime('%Y%m%d_%H%M')}]:"\
           ' Success! Snapshots table created.'
    end
  end
end
