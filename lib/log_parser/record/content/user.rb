module LogParser::Record::Content
  class User < Base
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def student?
      if @user_id =~ fetch_config(:student_id, :legal_pattern)
        %i(faculty department).all? do |item|
          fetch_config(item).values.flatten.map(&:to_s).include?(Regexp.last_match[item])
        end
      else
        false
      end
    end

    def join_year
      @user_id.slice(fetch_config(:student_id, :legal_pattern), :join_year) if student?
    end

    def faculty
      get_section(:faculty) if student?
    end

    def department
      get_section(:department) if student?
    end

    private

    def get_section(query)
      fetch_config(query).find {|_, codes|
        match = @user_id.slice(fetch_config(:student_id, :legal_pattern), query)
        codes.map(&:to_s).include?(match)
      }.first
    end
  end
end
