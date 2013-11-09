require 'observer'

class Employee
    include Observable
    attr_reader :name, :title
    attr_reader :salary

    def initialize(name, title, salary)
        super()
        @name      = name
        @title     = title
        @salary    = salary
    end

    def salary=(new_salary)
        old_salary = @salary
        @salary = new_salary
        if old_salary != new_salary
            changed
            notify_observers(self)
        end
    end

    def title=(new_title)
        old_title = @title
        @title = new_title
        if old_title != new_title
            changed
            notify_observers(self)
        end
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

