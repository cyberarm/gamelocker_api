class GameLockerAPI
  class Telemetry
    attr_accessor :events
    Event = Struct.new(:time, :type, :payload)
    def initialize(telemetry_url)
      @events  = []
      response = RestClient.get(telemetry_url)
      parse(response.body)
    end

    def parse(json)
      Oj.load(json).each do |event|
        @events << Event.new(event['time'], event['type'], event['payload'])
      end
    end
  end
end
