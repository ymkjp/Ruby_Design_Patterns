
class ArrayIterator
    def initialize(array)
        @array = array
        @index = 0
    end

    def has_next?
        @index < @array.length
    end

    def item
        @array[@index]
    end

    def next_item
        value = @array[@index]
        @index += 1
        value
    end
end

def main1
    array = ['red', 'green', 'blue']

    i = ArrayIterator.new(array)
    while i.has_next?
        puts "item: #{i.next_item.chr}"
    end
end
main1

def main2
    def for_each_element(array)
        i = 0
        while i < array.length
            yield(array[i])
            i += 1
        end
    end

    a = [10, 20, 30]
    for_each_element(a) {|element| puts "The element is #{element}"}

    a.each {|element| puts "The element is #{element}"}
end
main2

def main3
    def merge(array1, array2)
        merged = []

        iterator1 = ArrayIterator.new(array1)
        iterator2 = ArrayIterator.new(array2)

        while(iterator1.has_next? and iterator2.has_next?)
            if iterator1.item < iterator2.item
                merged << iterator1.next_item
            else
                merged << iterator2.next_item
            end
        end

        while (iterator1.has_next?)
                merged << iterator1.next_item
        end

        while (iterator2.has_next?)
                merged << iterator2.next_item
        end

        merged
    end

    a1 = [1, 2, 4, 6, 666, 8].sort!
    a2 = [1, 888, 4, 6, 666, 8].sort!

    p a1
    p a2
    p merge(a1, a2)
end
main3

