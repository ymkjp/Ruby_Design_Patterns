
class Render
    def render(text_object)
        text = text_object.text
        size = text_object.size_inches
        color = text_object.color

        # Show strings
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

class BritishTextObject
    attr_reader :string, :size_mm, :colour
    def initialize(string, size_mm, colour)
        @string = string
        @size_mm = size_mm
        @coluor = colour
    end

    # ...
end

bto = BritishTextObject.new('hello', 50.8, :blue)

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

# こういった方法は強力で単純ですが、複雑な処理を行う場合や対象のクラスのことをよく
# 知らない場合はアダプタをつくったほうがいい

