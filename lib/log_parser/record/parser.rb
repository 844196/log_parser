module LogParser::Record
  @record = Struct.new('Record', :pc, :user, :use_date_time) do
    def to_h
      members.inject({}) {|h,m| h.update(send(m).to_h) }
    end
  end

  def self.parse(row)
    @record.new(
      Content::PC.new(row[:client_id]),
      Content::User.new(row[:user_id]),
      Content::UseDateTime.new(
        :use_date      => row[:use_date],
        :startup_time  => row[:startup_time],
        :shutdown_time => row[:shutdown_time]
      )
    )
  end
end
