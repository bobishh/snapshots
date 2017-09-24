require 'yaml'

module Snapshots
  class Settings
    CONFIG_PATH = File.expand_path '../../../config/settings.yml', __FILE__

    def self.settings
      @@settings
    end

    @@settings = YAML.safe_load(File.read(CONFIG_PATH))['snapshots']

    class << self
      @@settings.keys.map do |key|
        define_method key do
          @@settings[key]
        end
      end
    end
  end
end
