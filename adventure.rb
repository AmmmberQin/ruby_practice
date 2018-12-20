#!/usr/bin/ruby

# dungeon adventure text game

class Room
    SIZE = ["huge", "large", "big", "regular", "small", "tiny"].freeze
    COLOR = ["red", "blue", "green", "dark", "golden", "crystal"].freeze
    ROOM_TYPE = ["cave", "treasure room", "rock cavern", "tomb", "guard room", "lair"].freeze
    DIRECTION = ["north", "south", "east", "west"].freeze

    def to_s
        "You are in a #{SIZE.sample} #{COLOR.sample} #{ROOM_TYPE.sample} room. There is an exit on the #{DIRECTION.sample} wall."
    end
end

class Dungeon
    TREASURE = ["gold coins", "gems", "a magic wand", "an enchanted sword"].freeze

    attr_reader :treasure_count, :escaped, :monster, :current_room
    
    def initialize
        @treasure_count = 0
        @escaped = false
        @monster = false
        @current_room = ""
    end

    def move
        @current_room = Room.new()
        @monster = has_monster?
        @escaped = has_escaped?
    end

    def fight
        if @monster
            if defeat_monster?
                puts "You defeated the scary monster!"
                @monster = false
            else
                puts "You attack and MISS!!!"
            end
        end
    end

    def search
        if has_treasure?
            puts "You found #{TREASURE.sample}"
            @treasure_count += 1
        else
            puts "You look, but don't find anything."
        end

        if not @monster
            @monster = has_monster?
        end
    end

    def monster_attack?
        roll_dice >= 9
    end

    private

    def has_monster?
        roll_dice >= 8
    end

    def has_escaped?
        roll_dice >= 11
    end

    def defeat_monster?
        roll_dice >= 4
    end

    def has_treasure?
        roll_dice >= 8
    end

    def roll_dice(number_of_dice=2, size_of_dice=6)
        total = 0
        1.upto(number_of_dice) do
            total += rand(size_of_dice) + 1
        end
        return total
    end

end

class Game
    def initialize(damage_points=5)
        @number_of_rooms_explored = 1
        @force_quit = false
        @damage_points = damage_points
        @dungeon = Dungeon.new()
    end

    def play
        puts "You are trapped in the dungeon. Collect treasure and try to escape"
        puts "before an evil monster gets you!"
        puts "To play, type one of the command choices on each turn"
        puts ""

        while @damage_points > 0 and not @dungeon.escaped do
            puts "Room number #{@number_of_rooms_explored}"
            puts @dungeon.current_room
            if @dungeon.monster
                puts "Oh no! An evil monster is in here with you!"
            end
            player_quit = player_action
            if player_quit
                break
            end
            puts ""
        end

        game_end
    end

    def player_action
        print "What do you do? (#{actions.join(', ')}): "
        play_action = gets.chomp
        if @dungeon.monster and @dungeon.monster_attack?
            @damage_points -= 1
            puts "OUCH, the monster bit you!"
        end

        if play_action == "m"
            @dungeon.move
            @number_of_rooms_explored += 1
        elsif play_action == "s"
            @dungeon.search
        elsif play_action == "f" and @dungeon.monster
            @dungeon.fight
        elsif play_action == "q"
            @force_quit = true
            return true
        else
            puts "I don't know how to do that!"
        end
        return false
    end


    def game_end
        if not @force_quit
            if @damage_points > 0
                user_escaped
            else
                user_die
            end
        else
            user_force_quit
        end
    end

    def actions
        ['m - move', 's - search', 'q - quit'] + (@dungeon.monster ? ["f - fight"] : [])
    end

    def user_escaped
        puts "You escaped!"
        puts "You explored #{@number_of_rooms_explored} rooms"
        puts "and found #{@treasure_count} treasures."
    end

    def user_die
        puts "OH NO! You didn't make it out!"
        puts "You explored #{@number_of_rooms_explored} rooms"
        puts "before meeting your doom"
    end

    def user_force_quit
        puts "Bye Bye"
    end

end

game = Game.new()
game.play







