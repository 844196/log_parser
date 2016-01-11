require 'spec_helper'

describe LogParser::Configuration do
  describe '.new' do
    it { expect { LogParser::Configuration.new }.to raise_error NoMethodError }
  end

  describe '.instance' do
    it { expect { LogParser::Configuration.instance }.not_to raise_error }

    it 'インスタンス変数へアクセスできること' do
      YAML.load_file(LogParser::DEFAULT_CONFIG_YAML_PATH).keys.each do |key|
        expect { LogParser::Configuration.instance.send(key) }.not_to raise_error
      end
    end
  end
end

describe LogParser do
  describe '.config' do
    it 'Configuration.instanceが返却されること' do
      expect(LogParser.config).to eq LogParser::Configuration.instance
    end
  end

  describe '.configure' do
    after (:all) { LogParser.yaml_load :path => LogParser::DEFAULT_CONFIG_YAML_PATH }

    it 'ブロックでConfiguration.instanceのインスタンス変数を変更できること' do
      default_value = LogParser.config.department

      set_value = 'hoge'
      LogParser.configure do |conf|
        conf.department = set_value
      end

      after_value = LogParser.config.department

      expect(after_value).not_to eq default_value
      expect(after_value).to eq set_value
    end
  end

  describe '.yaml_load' do
    before(:all) { LogParser.yaml_load :path => LogParser::DEFAULT_CONFIG_YAML_PATH }
    after (:all) { LogParser.yaml_load :path => LogParser::DEFAULT_CONFIG_YAML_PATH }

    shared_examples 'yamlをロードした場合' do
      it 'Configurationのインスタンス変数が更新されていること' do
        YAML.load_file(TEST_CONFIG_YAML_PATH).each do |k, yaml_value|
          expect(LogParser.config.instance_variable_get("@#{k}")).to eq yaml_value
        end
      end
    end

    context 'パス指定' do
      it { expect { LogParser.yaml_load :path => TEST_CONFIG_YAML_PATH }.not_to raise_error }
      it_behaves_like 'yamlをロードした場合'
    end

    context 'Fileオブジェクト' do
      it { expect { LogParser.yaml_load :file_obj => File.open(TEST_CONFIG_YAML_PATH) }.not_to raise_error }
      it_behaves_like 'yamlをロードした場合'
    end
  end
end
