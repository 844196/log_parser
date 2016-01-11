require 'spec_helper'

describe LogParser::Record::Content::UseDateTime do
  let(:use_date_time) { LogParser::Record::Content::UseDateTime.new(params) }

  describe '.new' do
    context 'startup_time < shutdown_time' do
      let(:params) {{
          :use_date      => Date.parse('2000/01/01'),
          :startup_time  => Time.parse('2000/01/01 12:34:56'),
          :shutdown_time => Time.parse('2000/01/01 12:35:56')
      }}
      it { expect { use_date_time }.not_to raise_error }
    end

    context 'startup_time > shutdown_time' do
      let(:params) {{
          :use_date      => Date.parse('2000/01/01'),
          :startup_time  => Time.parse('2000/01/01 12:35:56'),
          :shutdown_time => Time.parse('1999/12/31 12:34:56')
      }}
      it { expect { use_date_time }.to raise_error(ArgumentError, /shutdown_time must be after startup_time/) }
    end
  end

  describe '#uptime' do
    subject { use_date_time.uptime }

    context '2000/01/01 12:34:56 - 2000/01/01 12:35:56 (60secs)' do
      let(:params) {{
          :use_date      => Date.parse('2000/01/01'),
          :startup_time  => Time.parse('2000/01/01 12:34:56'),
          :shutdown_time => Time.parse('2000/01/01 12:35:56')
      }}
      it { is_expected.to eq 60 }
    end

    context '2000/01/01 12:34:56 - 2000/01/03 12:34:56 (2day, 172800secs)' do
      let(:params) {{
          :use_date      => Date.parse('2000/01/01'),
          :startup_time  => Time.parse('2000/01/01 12:34:56'),
          :shutdown_time => Time.parse('2000/01/03 12:34:56')
      }}
      it { is_expected.to eq 172800 }
    end
  end
end
