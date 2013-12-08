
class ClassVariableTester
    @@class_count = 0

    def initialize
        @instance_count = 0
    end

    def increment
        @@class_count = @@class_count + 1
        @instance_count = @instance_count + 1
    end

    def to_s
        "class_count: #{@@class_count}, instance_count: #{@instance_count}"
    end
end

c01 = ClassVariableTester.new
c01.increment
c01.increment
puts "c1: #{c01}"

# リセットされない
c02 = ClassVariableTester.new
puts "c2: #{c02}"

puts "\n===クラスメソッドをつくってみる==="
class SomeClass
    puts "クラス定義の内側で self は #{self}"
end


class SomeClass
    def self.class_level_method
        puts 'Hello from the class method'
    end
end
SomeClass.class_level_method

