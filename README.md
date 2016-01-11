# LogParser

[![Required Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.2.4-red.svg)](#)
[![Travis branch](https://img.shields.io/travis/844196/log_parser.svg)](https://travis-ci.org/844196/log_parser)

## Usage

```ruby
require 'log_parser'
require 'csv'

LogParser.yaml_load :file_obj => DATA

csv = <<-EOS
PC00101,ak1111054,2000/01/01,0:00:00,0:01:00
PC00203,sushi_tabetai,2000/01/01,12:34:56,15:31:58
EOS

records = []
CSV.parse(csv) do |client_id, user_id, use_date, startup_time, shutdown_time|
  records << LogParser::Record.parse({
    :client_id     => client_id,
    :user_id       => user_id,
    :use_date      => Date.parse(use_date),
    :startup_time  => Time.parse("#{use_date} #{startup_time}"),
    :shutdown_time => Time.parse("#{use_date} #{shutdown_time}")
  })
end

records[0].pc.place              #=> "1F"
records[0].user.department       #=> "keiei_keizai"
records[1].user.student?         #=> false
records[1].use_date_time.uptime  #=> 10622

__END__
:faculty:
  keizai:
    - ak
  hoken:
    - ah

:department:
  keiei_keizai:
    - 11
    - 12
  hoken_fukushi:
    - 61
    - 62

:place:
  1F: !ruby/regexp /PC001../
  2F: !ruby/regexp /PC002../

:student_id:
  :legal_pattern:
    !ruby/regexp /\A(?<faculty>\w{2})(?<join_year>\d{1,2})(?<department>\d{2})(?<range_number>\d{3})\z/
```
