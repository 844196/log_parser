module LogParser::Record::Content
  class UseDateTime < Base
    attr_reader :use_date, :startup_time, :shutdown_time

    def initialize(use_date:, startup_time:, shutdown_time:)
      raise(ArgumentError.new, 'shutdown_time must be after startup_time') unless startup_time < shutdown_time

      @use_date      = use_date
      @startup_time  = startup_time
      @shutdown_time = shutdown_time
    end

    def uptime
      (@shutdown_time - @startup_time).to_i # seconds
    end

    def to_h
      {
        :use_date      => @use_date,
        :startup_time  => @startup_time,
        :shutdown_time => @shutdown_time,
        :uptime        => uptime
      }
    end
  end
end
