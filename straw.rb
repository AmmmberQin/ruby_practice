puts "Welcome to the Last Straw Game"
puts "IN each round, players will draw straws of two different lengths"
puts "The PLayer who pick the short straw will be eliminated and a new round will begin"

PLAYERS = %w(anne bert chris donna ernie franz garfield holden ivy jose)

class Game
	def initialize(player_names)
		@players = []
		player_names.each do |name_|
			@players.push(Player.new(name_))
		end
		@rounds = 1
	end

	def done?
		@players.length <= 1
	end

	def show_round_number
		puts ""
		puts "----> Round #{@rounds}"
		puts ""
	end

	def play_round
		bundle_of_straws = setup_new_bundle
		0.upto(@players.length - 1) do |idx|
			player = @players[idx]
			player.straw = bundle_of_straws.pop
		end
	end

	def setup_new_bundle
		number_of_players = @players.length
		bundle = Straw.create_bundle(1, number_of_players - 1)
		bundle.shuffle
	end

	def show_results
		@players.each do |player|
			puts player.appearance
		end
	end

	def finish_round
		@players.delete_if do |player|

			player.short_straw?
		end
		@rounds += 1
	end

	def show_winner
		last_player = @players.first
		puts ""
		puts "The winner is #{last_player.name_}"
		puts ""
	end

end


class Player
	attr_reader :name_
	attr_accessor :straw

	def initialize(name_)
		@name_ = name_
	end

	def appearance
		"#{straw.appearance} #{name_}"
	end

	def short_straw?
		straw.short?
	end
end

class Straw
	SHORT_STRAW = 5
	LONG_STRAW = 20

	def initialize(size)
		@straw_size = size
	end

	def short?
		@straw_size == SHORT_STRAW
	end

	def appearance
		'=' * @straw_size
	end

	def self.create_bundle(short, long)
		bundle = []
		1.upto(short) do
			bundle << Straw.new(SHORT_STRAW)
		end

		1.upto(long) do
			bundle << Straw.new(LONG_STRAW)
		end

		bundle
	end
end


game = Game.new(PLAYERS)

while !game.done? do 
	game.show_round_number
	game.play_round
	game.show_results
	game.finish_round
end

game.show_winner 
