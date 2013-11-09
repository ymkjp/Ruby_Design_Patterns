require 'rexml/parsers/sax2parser'
require 'rexml/sax2listener'

xml = File.read(ARGV[0])
parser = REXML::Parsers::SAX2Parser.new(xml)

parser.listen(:start_element) do |uri, local, qname, attrs|
    puts "start element: #{uri}"
    puts "start element: #{local}"
    puts "start element: #{qname}"
    puts "start element: #{attrs}"
end

parser.listen(:end_element) do |uri, local, qname|
    puts "end element: #{uri}"
    puts "end element: #{local}"
    puts "end element: #{qname}"
end

parser.parse
