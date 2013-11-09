require './HTMLReport'
require './PlainTextReport'

report = HTMLReport.new
report.output_report

puts

report = PlainTextReport.new
report.output_report
