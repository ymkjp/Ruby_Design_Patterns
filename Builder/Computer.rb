
# コンピュータの部品を用意します
class Computer
    attr_accessor :display, :motherboard
    attr_reader :drives

    def initialize(display=:crt, motherboard=Motherboard.new, drives=[])
        @motherboard = motherboard
        @drives = drives
        @display = display
    end
end

class CPU
end

class BasicCPU < CPU
end

class TurboCPU < CPU
end

class Motherboard
    attr_accessor :cpu, :memory_size

    def initialize(cpu=BasicCPU.new, memory_size=1000)
        @cpu = cpu
        @memory_size = memory_size
    end
end

class Drive
    attr_reader :type  # :hard_disk, :cd, or :dvd
    attr_reader :size  # By MB
    attr_reader :writable  # By MB

    def initialize(type, size, writable)
        @type = type
        @size = size
        @writable = writable
    end
end

puts "さて、コンピュータを組み立てましょう"
motherboard = Motherboard.new(TurboCPU.new, 4000)
drives = []
drives << Drive.new(:hard_disk, 200000, true)
drives << Drive.new(:cd, 760, true)
drives << Drive.new(:dvd, 4700, false)
computer = Computer.new(:lcd, motherboard, drives)
p computer

# うーん、もっとスマートに組み立てられないでしょうか
# そこで Builder パターンの登場です

class ComputerBuilder
    attr_reader :computer

    def initialize
        @computer = Computer.new
        self
    end

    def turbo(has_turbo_cpu=true)
        @computer.motherboard.cpu = TurboCPU.new
        self
    end

    def display=(display)
        @computer.display = display
        self
    end

    def memory_size=(size_in_mb)
        @computer.motherboard.memory_size = size_in_mb
        self
    end

    def add_cd(writer=false)
        @computer.drives << Drive.new(:cd, 760, writer)
        self
    end

    def add_dvd(writer=false)
        @computer.drives << Drive.new(:dvd, 4000, writer)
        self
    end

    def add_hard_disk(size_in_mb)
        @computer.drives << Drive.new(:hard_disk, size_in_mb, true)
        self
    end

end

puts "\nBuilder パターンで組み立ててみましょう"
builder = ComputerBuilder.new
builder.display = :lcd
builder.turbo
builder.add_cd(true)
builder.add_dvd
builder.add_hard_disk(100000)
p builder.computer

puts "\nself を返すようにするとメソッドチェーンが使えて美しいですな"
p ComputerBuilder.new.
    # display=(:lcd).  # Fixme どうやったらいいんだ？
    # Computer.rb:109:in `<main>': undefined method `turbo' for :lcd:Symbol (NoMethodError)
    turbo.
    add_cd(true).
    add_dvd.
    add_hard_disk(100000).
    computer

# GoF はビルダオブジェクトのクライアントを director と呼んでいます
# 新しいオブジェクトの組み立てをビルダに指示するからです
# 作られるオブジェクトは product と呼ばれます

# Builder は複雑なオブジェクトを作る負荷を軽減するだけでなく、
# その実装の詳細を隠ぺいする役割ももっています
