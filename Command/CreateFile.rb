# Command Pattern
# 何を行うのかの決定と、その実行を分離できる
# 下記の例のように少しリッチなCLIをつくるときなどにつかえる
#
# Observer Pattern と似ている
# * Observer は状態を扱い、
# * Command は何を行うかを扱う

require 'FileUtils'

class Command
    attr_reader :description

    def initialize(description)
        @description = description
    end

    def execute
    end
end

class CreateFile < Command
    def initialize(path, contents)
        super("Create file: #{path}")
        @path = path
        @comtents = contents
    end

    def execute
        f = File.open(@path, 'w')
        f.write(@comtents)
        f.close
    end

    def unexecute
        File.delete(@path)
    end
end

class DeleteFile < Command
    def initialize(path)
        super("Delete file: #{path}")
        @path = path
    end

    def execute
        if File.exists?(@path)
            @contents = File.read(@path)
        end
        File.delete(@path)
    end

    def unexecute
        if @contents
            f = File.open(@path, "w")
            f.write(@contents)
            f.close
        end
    end
end

class CopyFile < Command
    def initialize(source, target)
        super("Copy file: #{source} to #{target}")
        @source = source
        @target = target
    end

    def execute
        if File.exists?(@target)
            @contents = File.read(@target)
        end
        FileUtils.copy(@source, @target)
    end

    def unexecute
        if @contents
            f = File.open(@target, "w")
            f.write(@contents)
            f.close
        end
    end
end

class CompositeCommand < Command
    def initialize
        @commands = []
    end

    def add_command(cmd)
        @commands << cmd
    end

    def execute
        @commands.each {|cmd| cmd.execute}
    end

    def unexecute
        @commands.reverse.each {|cmd| cmd.unexecute}
    end

    def description
        @commands.inject('') {|description, cmd| description += cmd.description + "\n"}
    end
end

cmds = CompositeCommand.new
cmds.add_command(CreateFile.new('file001.txt', "hello world\n"))
cmds.add_command(CopyFile.new('file001.txt', 'file002.txt'))
cmds.add_command(DeleteFile.new('file001.txt'))

# 実行前に説明を表示するのもお手の物
puts(cmds.description)
puts(cmds.execute)
puts(cmds.unexecute)

