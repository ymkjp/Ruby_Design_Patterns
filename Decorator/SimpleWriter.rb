
class SimpleWriter
    def initialize(path)
        @file = File.open(path, 'w')
    end

    def write_line(line)
        @file.print(line)
        @file.print("\n")
    end

    def pos
        @file.pos
    end

    def rewind
        @file.rewind
    end

    def close
        @file.close
    end
end

# 単調なメソッドのみを提供する親クラス
# デコラティブなメソッドは子の Writer に委譲する
class WriterDecorator
    def initialize(real_writer)
        @real_writer = real_writer
    end

    def write_line(line)
        @real_writer.write_line(line)
    end

    def pos
        @real_writer.pos
    end

    def rewind
        @real_writer.rewind
    end

    def close
        @real_writer.close
    end
end

# 先ほどの単調な親クラスはさえないため method_missing を使うことが頭に思い浮かぶが、
# ここでは Forwardable モジュールのほうが適しているのでそちらを利用する
require 'forwardable'
# Writerdecorator クラスを上書き
class WriterDecorator
    # include していない理由は、インスタンスメソッドではなくクラスのメソッドを追加したいだけだから
    extend Forwardable

    # Forwardable モジュールは2つ以上の引数をとる def_delegators クラスメソッドを提供する
    # * 1つめの引数はインスタンス属性の名前 (@をつける)
    # * その後の引数に1つ以上のメソッド名
    #
    # def_delegators メソッドは指定されたすべてのメソッドをクラスに追加する
    # Writerdecorator はそれぞれのメソッドを持ち、それらは @real_writer に委譲される
    #
    # method_missing との違いは、どのメソッドを委譲させるかを制御することができる点である
    # そのため使い分けはメソッドの移譲先の多さによって判断できる
    # * Forwardable モジュールは明示的に限られたメソッドを委譲したい場合
    # * method_missing は大量の呼び出しを委譲したいときに使う
    def_delegators :@real_writer, :write_line, :rewind, :pos, :close

    def initialize(real_writer)
        @real_writer = real_writer
    end
end

class NumberingWriter < WriterDecorator
    def initialize(real_writer)
        super(real_writer)
        @line_number = 1
    end

    def write_line(line)
        @real_writer.write_line("#{@line_number}: #{line}")
        @line_number += 1
    end
end

class ChecksummingWriter < WriterDecorator
    attr_reader :check_sum

    def initialize(real_writer)
        super(real_writer)
        #@real_writer = real_writer
        @check_sum = 0
    end

    def write_line(line)
        line.each_byte {|byte| @check_sum = (@check_sum + byte) % 256 }
        @check_sum += "\n"[0].to_i % 256
        @real_writer.write_line(line)
    end
end

class TimeStampingWriter < WriterDecorator
    def write_line(line)
        @real_writer.write_line("#{Time.new}: #{line}")
    end
end

# ./EnhancedWriter ではできていなかったメソッドの組み合わせが可能になっている
# 行番号を付加したテキストにタイムスタンプを入れ、最後にチェックサムを取る
writer = ChecksummingWriter.new(
    TimeStampingWriter.new(
        NumberingWriter.new(
            SimpleWriter.new('final.txt')))
)
writer.write_line('Hello out there')
puts "チェックサムは #{writer.check_sum}"

# 動的なデコレータ
# ===
# Ruby 流の気軽なラッピング
w = SimpleWriter.new('lightway.txt')
class << w
    alias old_write_line write_line

    def write_line(line)
        old_write_line("#{Time.now}: #{line}")
    end
end
w.write_line('How about timestamping wrapping ?')
# この方法の場合、行番号を2組出力しようとすると、2回 alias を呼んでしまって
# 元の write_line メソッドへの参照を失ってしまう点に注意が必要になる

# モジュールを使ったデコレータ
module TimeStampingWriterModule
    def write_line(line)
        super("#{Time.new}: #{line}")
    end
end

module NumberingWriterModule
    attr_reader :line_number
    def write_line(line)
        @line_number = 1 unless @line_number
        super("#{@line_number}: #{line}")
        @line_number += 1
    end
end
# かなり綺麗だがデコレータを取り除くことができなくなるのが難点
w = SimpleWriter.new('module_way.txt')
.extend(NumberingWriterModule)
.extend(TimeStampingWriterModule)
w.write_line('hello, module')

# まとめ
# =====
# デコレータは感心事を分離できるので作る人が好んで使う
# しかし呼び出しの手間は増えてしまうので、
# 使う人のための組み立て用のユーティリティ (おそらく Buider Pattern) を提供するのがよい
