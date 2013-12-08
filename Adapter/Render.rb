
class Render
    def render(text_object)
        text = text_object.text
        size = text_object.size_inches
        color = text_object.color

        # Show strings
        puts "#{text} の靴は #{size} インチで #{color} 色だ"
    end
end

class TextObject
    attr_reader :text, :size_inches, :color

    def initialize(text, size_inches, color)
        @text = text
        @size_inches = size_inches
        @color = color
    end
end

# Textobject とは異なったインターフェースをもつオブジェクト
class BritishTextObject
    attr_reader :string, :size_mm, :colour

    def initialize(string, size_mm, colour)
        @string = string
        @size_mm = size_mm
        @colour = colour
    end

    # ...
end

# Adapter パターンを使って解決
class BritishTextObjectAdapter < TextObject
    def initialize(bto)
        @bto = bto
    end

    def text
        return @bto.string
    end

    def size_inches
        return @bto.size_mm / 25.4
    end

    def color
        return @bto.colour
    end
end

text = BritishTextObjectAdapter.new(
    BritishTextObject.new('やまもと', 28, :blue)
)
Render.new.render(text)

class BritishTextObject
    attr_reader :string, :size_mm, :colour
    def initialize(string, size_mm, colour)
        @string = string
        @size_mm = size_mm
        @colour = colour
    end
end

bto = BritishTextObject.new('bto-san', 50.8, :blue)

# インスタンスごとにメソッドを追加できる
# オブジェクトに固有なメソッドを「特異メソッド (Singleton Method)」と呼ぶ
class << bto
    def color
        colour
    end
    
    def text
        string
    end

    def size_inches
        return size_mm/25.4
    end
end
Render.new.render(bto)

# すべてのインスタンスにメソッド追加を適用したい場合はクラスに追加することもできる
class BritishTextObject
    def color
        colour
    end
    
    def text
        string
    end

    def size_inches
        return size_mm/25.4
    end
end
Render.new.render(BritishTextObject.new('All', 50.8, :blue))

# こういった方法は強力で単純ですが、複雑な処理を行う場合や対象のクラスのことをよく
# 知らない場合はアダプタをつくったほうがいい

