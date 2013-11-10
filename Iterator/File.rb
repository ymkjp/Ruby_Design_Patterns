
# External Iterator
f = File.open('names.txt')
while not f.eof?
    puts f.readline
end
f.close

# Internal Iterator
f = File.open('names.txt')
f.each {|line| puts line}
f.close

