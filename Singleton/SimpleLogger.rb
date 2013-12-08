
class SimpleLogger
    attr_accessor :level

    ERROR   = 1
    WARNING = 2
    INFO    = 3

    def initialize
        @log = File.open('log.txt', 'w')
        @level = WARNING
    end

    def error(msg)
        @log.puts(msg)
        @log.flush
    end

    def warning(msg)
        @log.puts(msg) if @level >= WARNING
        @log.flush
    end

    def info(msg)
        @log.puts(msg) if @level >= INFO
        @log.flush
    end
end

logger = SimpleLogger.new
logger.level = SimpleLogger::INFO

logger.info('Do first processs')
logger.info('Do second processs')

class SimpleLogger
    @@instance = SimpleLogger.new

    def self.instance
        return @@instance
    end
end

# 同じオブジェクトが返る
p logger01 = SimpleLogger.instance
p logger02 = SimpleLogger.instance
logger01.info('We are same')
logger02.info('We are same, too')

# このようにメソッドを呼び出せる
SimpleLogger.instance.warning('ユニットAE-35の故障が予測されました。')
SimpleLogger.instance.error('HAL-9000 機能停止、緊急動作を実行します。')

# しかしこのままだと別のインスタンスを作られてしまうことを防げない
p SimpleLogger.new

# 別のインスタンスが作られることを防ぐために new をプライベートにする
class SimpleLogger
    private_class_method :new
end

p SimpleLogger.new rescue puts 'Singleton 機構の導入により新しい SimpleLogger インスタンスの作成に失敗しました'

# Singleton をつくれたものの、なかなかの手間だった
# 手順を洗い出してみると、
# 1. シングルトンインスタンスのためのクラス変数を用意
# 2. 変数にアクセスするためのクラスメソッドを用意 (self.instance)
# 3. new メソッドをプライベートにする

# これらを手軽に導入できるのが Singleton モジュール
require 'singleton'

class SimpleLogger
    include Singleton
end

SimpleLogger.instance.error('手軽に使えちゃうのね！')

# 上記で作成した自前の Singleton と Singleton モジュールには実は違いがある
#
# 自前のは積極的インスタンス化 (eager instantiation) と呼ばれる
# 実際に必要になる前にシングルトンインスタンスを作成する方法で、
# 一方、モジュールのほうは遅延インスタンス化 (lazy instantiation) と呼ばれる
# 実際に instance メソッドが呼ばれるまでシングルトンインスタンスを作成するのを待つ方法である
