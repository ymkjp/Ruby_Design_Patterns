require './Reporter'
require './Formatter'
require './HTMLFormatter'
require './PlainTextFormatter'

report = Reporter.new(HTMLFormatter.new)
report.output_report
report.formatter = PlainTextFormatter.new
report.output_report
