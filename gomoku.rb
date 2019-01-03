#!/usr/bin/ruby
class Cell
  RELATIVE_NEIGHBOUR_COORDINATES = {
    north: [-1, 0].freeze, north_east: [-1, 1].freeze,
    east:  [0, 1].freeze,  south_east: [1, 1].freeze,
    south: [1, 0].freeze,  south_west: [1, -1].freeze,
    west:  [0, -1].freeze, north_west: [-1, -1].freeze,
  }.freeze

  NEIGHBOUR_DIRECTIONS = RELATIVE_NEIGHBOUR_COORDINATES.keys.freeze
  PAIR_DIRECTIONS = [[:north, :south].freeze,
                     [:east, :west].freeze, 
                     [:north_east, :south_west].freeze, 
                     [:north_west, :south_east].freeze].freeze
  EMPTY = "."
  attr_accessor(*NEIGHBOUR_DIRECTIONS)
  def initialize
    @cell = EMPTY
  end
  
  def empty?
    @cell == EMPTY
  end

  def place?(piece)
    if empty? and valid_piece?(piece)
      @cell = piece
      return true
    end
    return false
  end

  def win?
    neighbours.compact.select{|x| x>=4}.length > 0
  end

  def [](direction)
    validate_direction(direction)
    send(direction)
  end

  def []=(direction, neighbour)
    validate_direction(direction)
    send("#{direction}=", neighbour)
  end

  def neighbours
    PAIR_DIRECTIONS.map{ |directions| 
      directions.map{|direction|
        self[direction].find_index{|neighbour| neighbour.to_s != self.to_s}
      }.compact.inject(:+)
    }
  end

  def to_s
    @cell
  end

  def inspect
    "<#{self.class} #{@cell}>"
  end

  private

  def validate_direction(direction)
    unless NEIGHBOUR_DIRECTIONS.map(&:to_s).include?(direction.to_s)
      raise "unsupported direction #{direction}"
    end
  end

  def valid_piece?(piece)
    piece != EMPTY
  end

end

class Grid
  attr_reader :gameover, :draw
  def initialize(width)
    @cells = Array.new(width * width).map { Cell.new }
    @grid = @cells.each_slice(width).to_a
    @gameover = false
    @draw = false
    @width = width
    assign_cell_neighbours
  end

  def update?(move, piece)
    x, y = move
    if x.negative? || x >= @width || y.negative? || y >= @width
      return false
    end
    cell = @grid.dig(x,y)
    if not cell.place?(piece)
      return false
    end

    if not full?
      @gameover = cell.win?
    else
      @gameover = true
      @draw = true
    end
    return true
  end

  def full?
    @cells.none?{|cell| cell.empty?}
  end

  def to_s
    @grid.map {|row| row.map(&:to_s).join}.join("\n")
  end

  private

  def assign_cell_neighbours
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        Cell::RELATIVE_NEIGHBOUR_COORDINATES.each do |dir, rel_coord|
          (rel_row_index, rel_column_index) = rel_coord
          neighbour_row_index = row_index
          neighbour_column_index = column_index
          neighbours = []
          loop do
            neighbour_row_index += rel_row_index
            neighbour_column_index += rel_column_index

            break if neighbour_row_index.negative? ||
                     neighbour_column_index.negative? ||
                     neighbour_row_index >= @width ||
                     neighbour_column_index >= @width
            neighbours << @grid.dig(neighbour_row_index, neighbour_column_index)
          end
          cell[dir] = neighbours
        end
      end
    end
  end
end

class Game
  def initialize(width=15)
    @width = width
    @users = ["A", "B"]
    @user_piece = {"A"=>"+", "B"=>"*"}
    @user_index = 0
  end

  def reset
    @grid = Grid.new(@width)
  end

  def start
    reset
    puts @grid
    until @grid.gameover
      user = @users[@user_index]
      print "Now for user<#{user}>, Enter your move(split by space)[0-#{@width-1}]:"
      begin
        move = gets.chomp.split.map(&:to_i)
        if not @grid.update?(move, @user_piece[user])
          puts "Invalid move!!!"
        else
          switch_user
          puts @grid
        end
      rescue
        puts "Invalid move!!!"
      end
    end
    show_result
  end

  def switch_user
    @user_index = (@user_index + 1) % @users.length
  end

  def show_result
    if not @grid.draw
      switch_user
      print "Game Over the Winner is <#{@users[@user_index]}>"
    else
      print "Game Over Draw"
    end
  end
end

game = Game.new(2)
game.start
