require 'spec_helper'
require 'log_parser'

describe LogParser::Record do
  describe '.parse' do
    let(:record) { LogParser::Record.parse(params) }
    let(:params) {{
        :client_id     => 'PC00100',
        :user_id       => 'ak1111054',
        :use_date      => Date.parse('2000/01/01'),
        :startup_time  => Time.parse('2000/01/01 12:34:56'),
        :shutdown_time => Time.parse('2000/01/01 12:34:57')
    }}
    it { expect { record }.not_to raise_error }

    describe 'return value' do
      it { expect(record).to be_a_kind_of Struct }
      it { expect(record.to_a).to include LogParser::Record::Content::User }
      it { expect(record.to_a).to include LogParser::Record::Content::PC }
      it { expect(record.to_a).to include LogParser::Record::Content::UseDateTime }
    end
  end
end
