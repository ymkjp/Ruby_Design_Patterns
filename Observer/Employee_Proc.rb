module Subject
    def initialize
        @observers = []
    end

    def notify_observers
        @observers.each do |observer|
            observer.call(self)
        end
    end

    def add_observer(&observer)
        @observers << observer
    end

    def remove_observer(observer)
        @observers.delete(observer)
    end
end

class Employee
    include Subject
    attr_reader :name, :title, :salary

    def initialize(name, title, salary)
        super()
        @name      = name
        @title     = title
        @salary    = salary
    end

    def salary=(new_salary)
        @salary = new_salary
        notify_observers
    end
end

fred = Employee.new(
    'Fred',
    'Crane Operator',
    30000.0,
)

fred.add_observer do |changed_employee|
    puts "#{changed_employee.name} の給料は"
    puts "#{changed_employee.salary} です"
end

fred.salary=350000.0

