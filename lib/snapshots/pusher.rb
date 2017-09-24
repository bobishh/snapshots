module Snapshots
  # notifies rabbitmq queue about incoming file
  class Pusher
    extend Forwardable
    def_delegator :@conn, :create_channel
    def_delegator :exchange, :publish

    def initialize(options)
      adapter = options[:adapter]
      bus_path = options[:bus_path]
      @conn = adapter.new(bus_path)
      @conn.start
    end

    def notify!(filepath, camera_id)
      exchange.publish(filepath, routing_key: camera_id)
    end

    private

    def exchange
      @exchange ||= begin
                      channel = create_channel
                      channel.topic('snapshots')
                    end
    end
  end
end
