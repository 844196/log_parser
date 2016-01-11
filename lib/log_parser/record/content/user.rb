module LogParser::Record::Content
  class User < Base
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def student?
      if @user_id =~ LogParser.config.student_id[:legal_pattern]
        %i(faculty department).all? do |item|
          LogParser.config.instance_variable_get("@#{item}").values.flatten.map(&:to_s).include?(Regexp.last_match[item])
        end
      else
        false
      end
    end

    def join_year
      @user_id.slice(LogParser.config.student_id[:legal_pattern], :join_year) if student?
    end

    def faculty
      get_section(:faculty)
    end

    def department
      get_section(:department)
    end

    private

    def get_section(query)
      if student?
        LogParser.config.instance_variable_get("@#{query}").find(->{[nil]}) {|_, codes|
          match = @user_id.slice(LogParser.config.student_id[:legal_pattern], query)
          codes.map(&:to_s).include?(match)
        }.first
      end
    end
  end
end
