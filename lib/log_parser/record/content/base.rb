module LogParser::Record::Content
  class Base

    private

    def fetch_config(p_key, *sub_keys)
      sub_keys.inject(LogParser.config.instance_variable_get("@#{p_key}")) do |obj, key|
        obj.fetch(key)
      end
    rescue
      nil
    end
  end
end
