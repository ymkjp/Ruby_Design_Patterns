
class BankAccount
    attr_reader :balance

    def initialize(starting_balance=0)
        @balance = starting_balance
    end

    def deposit(amount)
        @balance += amount
    end

    def withdraw(amount)
        @balance -= amount
    end
end

# Protection proxy
require 'etc'
class AccountProtectionProxy
    def initialize(real_account, owner_name)
        @subject = real_account
        @owner_name = owner_name
    end

    def method_missing(name, *args)
        check_access
        @subject.send(name, *args)
    end

    def check_access
        if Etc.getlogin != @owner_name
            raise "Illegal access: #{Etc.getlogin} cannot access account."
        end
    end
end


# 最大の嘘つき「仮想プロキシー」
# クライアントが実際にメソッドを呼び出した時にだけ実際のオブジェクトへの参照をつくるか、アクセスを行う

class VirtualAccountProxy
    def initialize(&creation_block)
        @creation_block = creation_block
    end

    def method_missing(name, *args)
        s = subject
        s.send(name, *args)
    end

    # ここがポイント
    def subject
        @subject || (@subject = @creation_block.call)
    end
end

account = VirtualAccountProxy.new { BankAccount.new(100) }
#proxy = AccountProtectionProxy.new(account, 'YOUR_USER_NAME')
proxy = AccountProtectionProxy.new(account, 'keso')
proxy.deposit(50)
proxy.withdraw(10)
puts proxy.balance

