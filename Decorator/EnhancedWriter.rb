# このクラスはあまり良くない例
# =====
# * メソッドを取り違えそう
# * チェックサムとタイムスタンプを同時に使いたい場合うまくいかない
class EnhancedWriter
    attr_reader :check_sum

    def initialize(path)
        @file        = File.open(path, "w")
        @check_sum   = 0
        @line_number = 1
    end

    def write_line(line)
        @file.print(line)
        @file.print("\n")
    end

    def checksumming_write_line(data)
        data.each_byte {|byte| @check_sum = (@check_sum + byte) % 256}
        @check_sum += "\n"[0].to_i % 256
        write_line(data)
    end

    def timestamping_write_line(data)
        write_line("#{Time.now}: #{data}")
    end

    def numbering_write_line(data)
        write_line("#{@line_number}: #{data}")
    end

    def close
        @file.close
    end
end

writer = EnhancedWriter.new('out.txt')
writer.write_line("飾り気のない一行を書き込んでみる")

writer.checksumming_write_line('チェックサム付きで書き込む')
puts "チェックサムは #{writer.check_sum}"

writer.timestamping_write_line('タイムスタンプ付きで書き込む')
writer.numbering_write_line('行番号付きで書き込む')

