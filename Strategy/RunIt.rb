def run_it
    puts 'Before the yield'
    yield
    puts 'After the yield'
end

run_it do
    puts 'Hello'
    puts 'Coming to you from inside the block'
end
