
class Duck
    def initialize(name)
        @name = name
    end

    def eat
        puts "🐦 #{@name} は食事中です"
    end

    def speak
        puts "🐦 #{@name} がガーガー鳴いています"
    end

    def sleep
        puts "🐦 #{@name} は静かに眠っています"
    end
end

class Pond
    def initialize(number_ducks)
        @ducks = []
        number_ducks.times do |i|
            duck = Duck.new("アヒル#{i}")
            @ducks << duck
        end
    end

    def simulate_one_day
        @ducks.each {|duck| duck.speak }
        @ducks.each {|duck| duck.eat }
        @ducks.each {|duck| duck.sleep }
    end
end

puts "[ 第一段階 ]"
pond = Pond.new(3)
pond.simulate_one_day

# 次にカエルを追加します
class Frog
    def initialize(name)
        @name = name
    end

    def eat
        puts "🐸 カエル #{@name} は食事中です"
    end

    def speak
        puts "🐸 カエル #{@name} はゲロゲロッと鳴いています"
    end

    def sleep
        puts "🐸 カエル #{@name} は眠りません。一晩中ゲロゲロ鳴いています"
    end
end

# Pond クラスでは明示的に Duck を指定してしまっているので変更する
# 変わらないものから変わりうるものを分離していこう
class Pond
    def initialize(number_animals)
        @animals = []
        number_animals.times do |i|
            # new_animal はサブクラスで定義されたメソッドを呼ぶ
            animal = new_animal("動物#{i}")
            @animals << animal
        end
    end

    def simulate_one_day
        @animals.each {|animal| animal.speak }
        @animals.each {|animal| animal.eat }
        @animals.each {|animal| animal.sleep }
    end
end

class DuckPond < Pond
    def new_animal(name)
        Duck.new(name)
    end
end

class FrogPond < Pond
    def new_animal(name)
        Frog.new(name)
    end
end

puts "\n[ 第2段階 ]"
pond = FrogPond.new(3)
pond.simulate_one_day

# このように「クラスの選択」の決定をサブクラスに押し付けるテクニックを
# Gof では Factory Method パターンと呼んでいる

class Algea
    def initialize(name)
        @name = name
    end

    def grow
        puts "🌱 藻 #{@name} は日光を浴びて育ちます"
    end
end

class WaterLily
    def initialize(name)
        @name = name
    end

    def grow
        puts "🌾 スイレン #{@name} は浮きながら日光を浴びて育ちます"
    end
end

class Pond
    def initialize(number_animals, number_plants)
        @animals = []
        number_animals.times do |i|
            animal = new_organism(:animal, "動物#{i}")
            @animals << animal
        end

        @plants = []
        number_plants.times do |i|
            plant = new_organism(:plant, "植物#{i}")
            @plants << plant
        end
    end

    def simulate_one_day
        @plants.each {|plant| plant.grow }
        @animals.each {|animal| animal.speak }
        @animals.each {|animal| animal.eat }
        @animals.each {|animal| animal.sleep }
    end
end

# 直感的にいけてない名前のクラスをつくる
# FrogAlgaePond, DuckAlgaePond, FrogWaterLilyPond はつくりたくないよね
class DuckWaterLilyPond < Pond
    def new_organism(type, name)
        if type == :animal
            Duck.new(name)
        elsif type == :plant
            WaterLily.new(name)
        else
            raise "Unknown organism type: #{type}"
        end
    end
end

puts "\n[ 第3段階 ]"
pond = DuckWaterLilyPond.new(3, 2)
pond.simulate_one_day

# いけてるクラスにするにはどうすればいいんだろう
class Pond
    def initialize(number_animals, animal_class,
                   number_plants, plant_class)
        # Duck クラスたちをインスタンス変数に格納してみよう
        # これで池のサブクラスは必要なくなった
        @animal_class = animal_class
        @plant_class = plant_class

        @animals = []
        number_animals.times do |i|
            animal = new_organism(:animal, "動物#{i}")
            @animals << animal
        end

        @plants = []
        number_plants.times do |i|
            plant = new_organism(:plant, "植物#{i}")
            @plants << plant
        end
    end

    def simulate_one_day
        @plants.each {|plant| plant.grow }
        @animals.each {|animal| animal.speak }
        @animals.each {|animal| animal.eat }
        @animals.each {|animal| animal.sleep }
    end

    def new_organism(type, name)
        # ここで渡された Duck クラスたちを new しちゃう
        if type == :animal
            @animal_class.new(name)
        elsif type == :plant
            @plant_class.new(name)
        else
            raise "Unknown organism type: #{type}"
        end
    end
end

puts "\n[ 第4段階 ]"
# おぉ、かなりぽくなってきた
pond = Pond.new(3, Duck, 2, WaterLily)
pond.simulate_one_day

# Pond と同じレベルの生態系「ジャングル」が必要になった
class Tree
    def initialize(name)
        @name = name
    end

    def grow
        puts "🌴 樹木 #{@name} が高く育っています"
    end
end

class Tiger
    def initialize(name)
        @name = name
    end

    def eat
        puts "🐯 トラ #{@name} は食べたいものをなんでも食べます"
    end

    def speak
        puts "🐯 トラ #{@name} はガオーと吠えています"
    end

    def sleep
        puts "🐯 トラ #{@name} は眠くなったら眠ります"
    end
end

# 本来は Pond 丸コピ。今回は継承で手抜き。
class Habitat < Pond
end

puts "\n[ 第4段階 ]"
jungle = Habitat.new(1, Tiger, 4, Tree)
jungle.simulate_one_day
pond = Habitat.new(2, Duck, 4, WaterLily)
pond.simulate_one_day

# さて、ここまでの問題点は Habitat が生態学的にありえない動植物の組み合わせをつくれてしまうことだ
# これを解決するために Habitat につじつまのあったオブジェクトを一括して渡してくれるクラスをつくることにする

# Abstract Factory (抽象的な工場) と呼ばれる GoF パターンの1つである
class PondOrganismFactory
    def new_animal(name)
        Frog.new(name)
    end

    def new_plant(name)
        Algea.new(name)
    end
end

class JungleOrganismFactory
    def new_animal(name)
        Tiger.new(name)
    end

    def new_plant(name)
        Tree.new(name)
    end
end

class Habitat
    def initialize(number_animals, number_plants, organism_factory)
        @organism_factory = organism_factory

        @animals = []
        number_animals.times do |i|
            # 同クラス内のメソッド呼び出しから専用のクラスに委譲した
            # animal = new_organism(:animal, "動物#{i}")
            animal = @organism_factory.new_animal("動物#{i}")
            @animals << animal
        end

        @plants = []
        number_plants.times do |i|
            # plant = new_organism(:plant, "植物#{i}")
            plant = @organism_factory.new_plant("植物#{i}")
            @plants << plant
        end
    end
end

# かなりいいかんじだ
# でももっといけるんじゃないか？
puts "\n[ 第5段階 ]"
jungle = Habitat.new(1, 4, JungleOrganismFactory.new)
jungle.simulate_one_day
pond = Habitat.new(2, 4, PondOrganismFactory.new)
pond.simulate_one_day

# こうだ！
class OrganismFactory
    def initialize(plant_class, animal_class)
        @plant_class = plant_class
        @animal_class = animal_class
    end

    def new_animal(name)
        @animal_class.new(name)
    end

    def new_plant(name)
        @plant_class.new(name)
    end
end
puts "\n[ 第6段階 ]"
jungle_organism_factory = OrganismFactory.new(Tree, Tiger)
pond_organism_factory = OrganismFactory.new(WaterLily, Frog)
jungle = Habitat.new(1, 4, jungle_organism_factory)
pond = Habitat.new(2, 4, pond_organism_factory)
jungle.simulate_one_day
pond.simulate_one_day

# Factory 系パターンは特にYAGNI原則を忘れないように
