# Users Report

Application takes txt file and generates users report

## Setup

Unzip data file:

    $ gunzip data_large.txt.gz

Run this command to install dependencies:

    $ ./bin/setup

## Usage

Run ruby console:

    $ ./bin/console

And then execute:
```ruby
require 'benchmark'

Benchmark.realtime do
  users_report = UsersReport::Report.new('data_large.txt')
  users_report.generate!
  File.write('result.json', "#{users_report.to_json}\n")
end
```

## Testing

Run rspec:

    $ bundle exec rake spec
