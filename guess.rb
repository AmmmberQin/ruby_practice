#!/usr/bin/ruby

# guess number text game


class Game
    TOTAL_ROUNDS = 3
    def initialize(player)
        @player = player
        @round = 0
        next_round
    end

    def next_round
        @computers_number = 0
        @round_done = false
        @round += 1
        @player.prepare_for_new_round
    end

    def round
        @round
    end

    def done?
        @round > TOTAL_ROUNDS
    end

    def round_done?
        @round_done
    end

    def get_high_number
        print "I'll pick a number between 1 and what number? "
        high_number = @player.get_high_number
        if high_number <= 1
            puts "Oops! The number must be larger than 1. Try again."
            return false 
        else
            return true
        end
    end

    def get_guess_count
        average = calculate_typical_number_of_guesses
        puts "How many guesses do you think it will take?"
        total_guess_count = @player.get_total_guess_count
        if total_guess_count < 1
            puts "Seriously #{@player.name_}?! You need to at least try!"
            return false
        else
            return true
        end
    end

    def calculate_typical_number_of_guesses
        typical_count = Math.sqrt(@player.high_number)
        typical_count.round
    end

    def prepare_computer_number
        @computers_number = rand(@player.high_number) + 1
    end

    def get_player_guess
        print "#{@player.name_}, what is your guess? "
        @player.get_guess
        compare_player_guess_to_computer_number
    end

    def compare_player_guess_to_computer_number
        if @player.current_guess == @computers_number
            @round_done = true
            puts "YEAH!!!!!! You guessed it!"
            calculate_score
        else
            show_hint
        end
    end

    def show_hint
        hints = ["low","high"]
        if @player.current_guess < @computers_number
            hint_index = 0
        else
            hint_index = 1
        end
        if !tell_truth?
            hint_index -= 1
            hint_index = hint_index.abs
        end
        puts "HINT: You are too #{hints[hint_index]}"
    end

    def tell_truth?
        rand(100) >= 4
    end

    def calculate_score
        score = 0
        if @player.guess_count > @player.total_guess_count
            score = 1
        elsif @player.total_guess_count < calculate_typical_number_of_guesses
            score = 3
        else
            score = 5
        end

        @player.add_score(score)
    end

    def show_results
        puts "Guess count: #{@player.guess_count} target: #{@player.total_guess_count}"
    end

    def print_final_score
        puts "Final score for #{@player.name_} is #{@player.score}"
    end
end

class Player
    def initialize(name_)
        @name_ = name_
        @score = 0
        prepare_for_new_round
    end

    def prepare_for_new_round
        @total_guess_count = 0
        @high_number = 0
        @current_guess = 0
        @current_number_of_guesses = 0
    end

    def name_
        @name_
    end

    def score
        @score
    end

    def total_guess_count
        @total_guess_count
    end

    def high_number
        @high_number
    end

    def current_guess
        @current_guess
    end

    def guess_count
        @current_number_of_guesses
    end

    def add_score(points)
        @score += points
    end

    def get_high_number
        @high_number = gets.to_i
    end

    def get_total_guess_count
        @total_guess_count = gets.to_i
    end

    def get_guess
        @current_number_of_guesses += 1
        @current_guess = gets.to_i
    end

end

puts "Welcome to the Guessing Game"
puts "We will play #{Game::TOTAL_ROUNDS} rounds. Try to guess the number"
puts "I'm thinking of in the fewest guesses."
puts "You'll also estimate how many guesses it will take."
puts "If you do it in fewer guesses, you'll gain bonus points!"
puts ""

print "What is your name?"
name_ = gets.chomp
player = Player.new(name_)
game = Game.new(player)

while !game.done? do
    puts ""
    puts "------> Round ##{game.round}"
    puts ""

    if game.get_high_number
        if game.get_guess_count
            game.prepare_computer_number
            while !game.round_done? do
                puts ""
                game.get_player_guess
                game.show_results
            end
            game.next_round
        end
    end
end

puts ""
game.print_final_score
