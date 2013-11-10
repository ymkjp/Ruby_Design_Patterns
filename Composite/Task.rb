=begin

Composit means 複合的

下記のオブジェクトをつくりたいときに適している
- 階層構造
- ツリー構造

=end

# Component
class Task
    attr_accessor :name, :parent

    def initialize(name)
        @name = name
        @parent = nil
    end

    def get_time_required
        0.0
    end

    def total_number_basic_tasks
        1
    end
end

# Composite
class CompositeTask < Task
    def initialize(name)
        super(name)
        @sub_tasks = []
    end

    def [](index)
        @sub_tasks[index]
    end

    def []=(index, new_value)
        @sub_tasks[index] = new_value
    end

    def <<(task)
        @sub_tasks << task
        task.parent = self
    end

    def remove_sub_task(task)
        @sub_tasks.delete(task)
        task.parent = nil
    end

    def get_time_required
        time = 0.0
        @sub_tasks.each {|task|
            time += task.get_time_required
        }
        time
    end

    def total_number_basic_tasks
        total = 0
        @sub_tasks.each {|task|
            total += task.total_number_basic_tasks
        }
        total
    end
end

# Leaf
class MakeBatterTask < CompositeTask
    def initialize
        super('Make batter')
        @sub_tasks = []
        @sub_tasks << AddDryIngredientsTask.new
        @sub_tasks << MixTask.new
    end
end

class AddDryIngredientsTask < Task
    def initialize
        super('Add dry ingredients')
    end

    def get_time_required
        1.0  # 1 min. for add flour and sugger
    end
end

class MixTask < Task
    def initialize
        super('Mix that batter up!')
    end

    def get_time_required
        3.0  # 3 min. for mix
    end
end

first = CompositeTask.new('1st')
second = CompositeTask.new('2nd')
puts first.get_time_required
puts first.total_number_basic_tasks

first << MixTask.new
second << AddDryIngredientsTask.new
second << MakeBatterTask.new
puts '=== time ==='
puts "#{first.name}: #{first.get_time_required}"
puts "#{second.name}: #{second.get_time_required}"
puts '=== total ==='
puts "#{first.name}: #{first.total_number_basic_tasks}"
puts "#{second.name}: #{second.total_number_basic_tasks}"


