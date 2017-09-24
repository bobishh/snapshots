require 'base64'

module Snapshots
  # generic save error
  class SaveError < StandardError; end

  # storage class
  class Store
    def initialize(options)
      @uploads_path = options.fetch(:storage_path)
    end

    def save!(shot)
      maybe_mkdir(shot['camera_id'])
      filepath = File.join(@uploads_path, shot['camera_id'], timestamp_name)
      save_image(decode_image(shot['file']), filepath)
      return filepath unless block_given?
      yield filepath
    rescue => e
      raise SaveError, "Snapshot couldn't be saved: #{e.message}"
    end

    private

    def save_image(image, path)
      f = File.open(path, 'w+')
      f.write(image)
      f.close
    end

    def timestamp_name
      Time.now.strftime('snapshot_%Y%m%d_%H%M.jpg')
    end

    def decode_image(string)
      Base64.decode64(string)
    end

    def maybe_mkdir(camera_id)
      path = File.join(@uploads_path, camera_id)
      return true if File.exist? path
      FileUtils.mkdir(path)
    end
  end
end
