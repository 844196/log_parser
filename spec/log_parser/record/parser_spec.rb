require 'spec_helper'

describe LogParser::Record do
  before { LogParser.yaml_load :path => TEST_CONFIG_YAML_PATH }
  after  { LogParser.yaml_load :path => LogParser::DEFAULT_CONFIG_YAML_PATH }

  describe '.parse' do
    let(:record) { LogParser::Record.parse(params) }
    let(:use_date) { Date.parse('2000/01/01') }
    let(:startup_time) { Time.parse('2000/01/01 12:34:56') }
    let(:shutdown_time) { Time.parse('2000/01/01 12:34:57') }
    let(:params) {{
        :client_id     => 'PC00100',
        :user_id       => 'ak1111054',
        :use_date      => use_date,
        :startup_time  => startup_time,
        :shutdown_time => shutdown_time
    }}
    it { expect { record }.not_to raise_error }

    describe 'return value' do
      it { expect(record).to be_a_kind_of Struct }
      it { expect(record.to_a).to include LogParser::Record::Content::User }
      it { expect(record.to_a).to include LogParser::Record::Content::PC }
      it { expect(record.to_a).to include LogParser::Record::Content::UseDateTime }

      describe '#to_h' do
        subject { record.to_h }
        it do
          expect_hash = {
            :client_id     => 'PC00100',
            :place         => '1F',
            :user_id       => 'ak1111054',
            :student?      => true,
            :join_year     => '11',
            :faculty       => 'keizai',
            :department    => 'keiei_keizai',
            :use_date      => use_date,
            :startup_time  => startup_time,
            :shutdown_time => shutdown_time,
            :uptime        => 1
          }
          is_expected.to eq expect_hash
        end
      end
    end
  end
end
