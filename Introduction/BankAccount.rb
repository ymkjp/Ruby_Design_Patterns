module HelloModule
    def say_hello
        puts 'dello out there'
    end
end

class BankAccount
    include HelloModule
    attr_accessor :balance, :grace, :agility
    attr_reader :name

    def initialize account_owner
        @owner = account_owner
        @balance = 0
    end

    def deposit amount
        @balance = @balance + amount
    end

    def withdraw amount
        @balance = @balance - amount
    end

    def talk_about_me
        puts "Hell I am #{self}"
    end
end

class InterestBearingAccount < BankAccount
    def initialize owner, rate
        super(owner)
        @rate = rate
    end

    def deposti_interest
        @balance += @rate * @balance
    end
end

my_account = InterestBearingAccount.new('Russ', 0.2)
puts my_account.balance = 80
puts my_account.deposti_interest
puts my_account.say_hello
