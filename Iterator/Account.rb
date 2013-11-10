
class Account
    attr_accessor :name, :balance

    def initialize(name, balance)
        @name = name
        @balance = balance
    end

    def <=>(other)
        ballance <=> other.balance
    end
end

class Portfolio
    include Enumerable

    def initialize
        @accounts = []
    end

    def each(&block)
        @accounts.each(&block)
    end

    def add_account(account)
        @accounts << account
    end
end

my_portfolio = Portfolio.new
my_portfolio.add_account(Account.new('Salary', 10))
my_portfolio.add_account(Account.new('Flush funds', 1000))
puts my_portfolio.any? {|account| account.balance > 200}
puts my_portfolio.all? {|account| account.balance > 10}
