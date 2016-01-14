require 'spec_helper'

describe LogParser::Record::Content::User do
  before { LogParser.yaml_load :path => TEST_CONFIG_YAML_PATH }
  after  { LogParser.yaml_load :path => LogParser::DEFAULT_CONFIG_YAML_PATH }

  expects = [
    {:user_id => 'ak1111054',
     :expect  => {:user_id    => 'ak1111054',
                  :student?   => true,
                  :join_year  => '11',
                  :faculty    => 'keizai',
                  :department => 'keiei_keizai'}},
    {:user_id => 'ah9961999',
     :expect  => {:user_id    => 'ah9961999',
                  :student?   => true,
                  :join_year  => '99',
                  :faculty    => 'hoken',
                  :department => 'hoken_fukushi'}},
    {:user_id => '844196',
     :expect  => {:user_id    => '844196',
                  :student?   => false,
                  :join_year  => nil,
                  :faculty    => nil,
                  :department => nil}},
    {:user_id => 'ak1199054',
     :expect  => {:user_id    => 'ak1199054',
                  :student?   => false,
                  :join_year  => nil,
                  :faculty    => nil,
                  :department => nil}},
    {:user_id => 'ab1111054',
     :expect  => {:user_id    => 'ab1111054',
                  :student?   => false,
                  :join_year  => nil,
                  :faculty    => nil,
                  :department => nil}},
    {:user_id => 'ab1199054',
     :expect  => {:user_id    => 'ab1199054',
                  :student?   => false,
                  :join_year  => nil,
                  :faculty    => nil,
                  :department => nil}}
  ]

  shared_examples 'return values' do |item|
    let(:user) { LogParser::Record::Content::User.new(item[:user_id]) }

    describe '#student?' do
      it { expect(user.student?).to eq item[:expect][:student?] }
    end

    describe '#join_year' do
      it { expect(user.join_year).to eq item[:expect][:join_year] }
    end

    describe '#faculty' do
      it { expect(user.faculty).to eq item[:expect][:faculty] }
    end

    describe '#faculty' do
      it { expect(user.department).to eq item[:expect][:department] }
    end

    describe '#to_h' do
      it { expect(user.to_h).to eq item[:expect] }
    end
  end

  expects.each do |item|
    context "when user_id is '#{item[:user_id]}'" do
      it_behaves_like 'return values', item
    end
  end
end
