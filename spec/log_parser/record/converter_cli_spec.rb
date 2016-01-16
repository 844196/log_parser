require 'spec_helper'

describe LogParser::Record::ConverterCLI do
  let(:cli) { LogParser::Record::ConverterCLI.new }

  describe '#convert' do
    context 'when a valid csv file has been input' do
      it 'should to be succeed in convert' do
        input_csv, expect_csv = <<-CSV.gsub(/^\s+/, '').split(/===\n/)
          client_id,user_id,use_date,startup_time,shutdown_time
          PC00101,ak1111054,2000/01/01,12:34:56,13:00:00
          PC00201,ah961999,2000/02/02,12:34:56,13:00:00
          PC00102,teacher,2000/03/03,12:34:56,13:00:00
          PCIDOU1,ak1111054,2000/04/04,12:34:56,13:00:00
          ===
          client_id,place,user_id,student?,join_year,faculty,department,use_date,startup_time,shutdown_time,uptime
          PC00101,1F,ak1111054,true,11,keizai,keiei_keizai,2000/01/01,12:34:56,13:00:00,1504
          PC00201,2F,ah961999,true,9,hoken,hoken_fukushi,2000/02/02,12:34:56,13:00:00,1504
          PC00102,1F,teacher,false,,,,2000/03/03,12:34:56,13:00:00,1504
          PCIDOU1,unknown,ak1111054,true,11,keizai,keiei_keizai,2000/04/04,12:34:56,13:00:00,1504
        CSV

        Tempfile.create(%w[LogParser .csv]) do |csv|
          File.open(csv, 'w') {|f| f.puts(input_csv) }
          expect(capture(:stdout) { cli.invoke(:convert, [csv.path], {yaml: TEST_CONFIG_YAML_PATH}) }).to eq expect_csv
        end
      end
    end

    context 'when invalid csv fine has been input' do
      context 'no header' do
        it do
          input_csv, expect_csv = <<-CSV.gsub(/^\s+/, '').split(/===\n/)
            PC00101,ak1111054,2000/01/01,12:34:56,13:00:00
            PC00201,ah961999,2000/02/02,12:34:56,13:00:00
            PC00102,teacher,2000/03/03,12:34:56,13:00:00
            PCIDOU1,ak1111054,2000/04/04,12:34:56,13:00:00
            ===
          CSV

          Tempfile.create(%w[LogParser .csv]) do |csv|
            File.open(csv, 'w') {|f| f.puts(input_csv) }
            expect { cli.invoke(:convert, [csv.path], {yaml: TEST_CONFIG_YAML_PATH}) }.to raise_error(ArgumentError, /No header line at this csv file/)
          end
        end
      end
    end
  end

  describe '#help' do
    describe 'help' do
      it { expect { cli.invoke(:help, []) }.not_to raise_error }
    end

    describe 'help convert' do
      it { expect { cli.invoke(:help, ['convert']) }.not_to raise_error }
    end
  end
end
