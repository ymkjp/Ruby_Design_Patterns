module Subject
    def initialize
        @observers = []
    end

    def notify_observers
        @observers.each do |observer|
            observer.update(self)
        end
    end

    def add_observer(observer)
        @observers << observer
    end

    def remove_observer(observer)
        @observers.delete(observer)
    end
end

class Employee
    include Subject
    attr_reader :name, :title
    attr_reader :salary

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

class Payroll
    def update (changed_employee)
        puts "#{changed_employee.name} の給料は
        #{changed_employee.salary} です"
    end
end

class TaxMan
    def update (changed_employee)
        puts "#{changed_employee.name}
        に新しい税金の請求書を送ります"
    end
end


fred = Employee.new(
    'Fred',
    'Crane Operator',
    30000.0,
)

payroll = Payroll.new
tax_man = TaxMan.new
fred.add_observer(payroll)
fred.add_observer(tax_man)

fred.salary=350000.0

