module LogParser::Record
  class ConverterCLI < Thor
    default_task :convert

    desc 'convert <CSV_PATH>', 'convert csv file'
    method_option(:yaml,
                  :desc     => 'Specify config.yml path',
                  :required => true,
                  :type     => :string,
                  :banner   => 'YAML_PATH',
                  :aliases  => '-y')
    method_option(:col_sep,
                  :desc     => 'Specify field separator',
                  :required => false,
                  :type     => :string,
                  :banner   => 'CHAR',
                  :default  => ',',
                  :aliases  => '-c')
    def convert(csv_path)
      LogParser.yaml_load :path => options.yaml
      records = csv2hash(csv_path, options.col_sep)
      records.map! {|row| record_parser(row) }

      puts CSV.generate(:col_sep => options.col_sep) {|csv|
        records.each_with_index do |record, index|
          h = record.members.inject({}) {|hash,item| hash.update(record.send(item).to_h) }.map {|k,v|
            case v
            when Date then [k, v.strftime('%Y/%m/%d')]
            when Time then [k, v.strftime('%H:%M:%S')]
            else [k, v]
            end
          }.to_h
          csv << h.keys if index.zero?
          csv << h.values
        end
      }
    end

    private

    def str2time(str)
      Time.local(*str.split(/[\-\/\s:]/))
    end

    def csv2hash(csv_path, col_sep)
      header, *records = CSV.read(csv_path, :skip_blanks => true, :col_sep => col_sep)
      header.map!(&:to_sym)
      %i[client_id user_id use_date startup_time shutdown_time].each do |field|
        raise(ArgumentError.new, 'No header line at this csv file') unless header.include?(field)
      end
      records.map! {|e| header.zip(e).to_h }
    end

    def record_parser(row)
      LogParser::Record.parse(:client_id     => row[:client_id].upcase,
                              :user_id       => row[:user_id].downcase,
                              :use_date      => Date.parse(row[:use_date]),
                              :startup_time  => str2time("#{row[:use_date]} #{row[:startup_time]}"),
                              :shutdown_time => str2time("#{row[:use_date]} #{row[:shutdown_time]}"))
    end
  end
end
