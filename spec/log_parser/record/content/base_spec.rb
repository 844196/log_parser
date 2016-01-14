require 'spec_helper'

describe LogParser::Record::Content::Base do
  before do
    LogParser.configure do |config|
      config.faculty = 'not nested variable'
      config.department = {:nest_level_1=> {:nest_level_2=> ['nested variable']}}
    end

    class TestClass < LogParser::Record::Content::Base
      def wrap_fetch_config(*args)
        fetch_config(*args)
      end
    end
  end

  let(:test_class) { TestClass.new }

  describe 'fetch_config (private method)' do
    describe 'behavior' do
      it 'call unavailable as instance method' do
        expect { test_class.fetch_config(nil) }.to raise_error(NoMethodError, /private method `fetch_config' called/)
      end

      it 'call available as private method' do
        expect { test_class.wrap_fetch_config(nil) }.not_to raise_error
      end
    end

    describe 'fetch values' do
      subject { test_class.wrap_fetch_config(*params) }

      context 'target not nested' do
        let(:params) { [:faculty] }
        it { is_expected.to eq 'not nested variable' }
      end

      context 'target nested' do
        let(:params) { [:department, :nest_level_1, :nest_level_2, 0] }
        it { is_expected.to eq 'nested variable' }
      end

      context 'invalid arguments' do
        context 'not exist instance variable' do
          let(:params) { [:not_exist_instance_variable] }
          it { is_expected.to be_nil }
        end

        context 'exist instance variable, but not exist key' do
          let(:params) { [:faculty, :not_exist_key] }
          it { is_expected.to be_nil }
        end
      end
    end
  end

  describe '#to_h' do
    it { expect { test_class.to_h }.to raise_error(RuntimeError, /Called abstract method/) }
  end
end
