require_relative "game"
require_relative "deck"
require_relative "card"
require_relative "player"

STARTING_NUMBER_OF_CHIPS = 10
MINIMUM_PLAYERS = 2

puts "Welcome tp Acey Deucy"
print "Enter number of players: "
player_count = gets.to_i

if player_count >= MINIMUM_PLAYERS
	players = []
else
	puts "There should be at lease #{MINIMUM_PLAYERS}"
end

(0...player_count).each do |idx|
	print "Enter name for player ##{idx+1}: "
	name_ = gets.chomp
	players << Player.new(name_, STARTING_NUMBER_OF_CHIPS)
end

game_engine = Game.new(players)
game_engine.show_player_chips
game_engine.play