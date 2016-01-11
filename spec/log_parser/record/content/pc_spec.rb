require 'spec_helper'

describe LogParser::Record::Content::PC do
  before { LogParser.yaml_load :path => TEST_CONFIG_YAML_PATH }
  after  { LogParser.yaml_load :path => LogParser::DEFAULT_CONFIG_YAML_PATH }

  let(:pc) { LogParser::Record::Content::PC.new(client_id) }

  describe '#place' do
    subject { pc.place }

    context 'known client_id is "PC00199" (at 1F)' do
      let(:client_id) { 'PC00199' }
      it { is_expected.to eq '1F' }
    end

    context 'known client_id is "PC00299" (at 2F)' do
      let(:client_id) { 'PC00299' }
      it { is_expected.to eq '2F' }
    end

    context 'unknown client_id is "PC99999"' do
      let(:client_id) { 'PC99999' }
      it { is_expected.to eq 'unknown' }
    end
  end
end
