module LogParser::Record::Content
  class PC < Base
    attr_reader :client_id

    def initialize(client_id)
      @client_id = client_id
    end

    def place
      LogParser.config.place.find(->{['unknown']}) {|place, regexp|
        regexp === @client_id
      }.first
    end
  end
end
