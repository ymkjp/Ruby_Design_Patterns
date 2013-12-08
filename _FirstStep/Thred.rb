thred1 = Thread.new do
    sum = 0
    1.upto(10) {|x|
        sum = sum + x
    }
    puts "10までの整数の和は #{sum}"
end

thred2 = Thread.new do
    product = 1
    1.upto(10) {|x|
        product = product * x
    }
    puts "10までの整数の和は #{product}"
end

thred1.join
thred2.join
