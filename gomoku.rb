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
  attr_accessor(*NEIGHBOUR_DIRECTIONS)
  def initialize
    @cell = "."
  end
  
  def empty?
    @cell == "."
  end

  def place(piece)
    if empty?
      @cell = piece
    end
  end

  def win?
    neighbours.select{|x| x>=5}.length > 0
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
    PAIR_DIRECTIONS.map{ |dir_a, dir_b|
      self[dir_a].find_index{|neighbour| neighbour.to_s != self.to_s} + 
      self[dir_b].find_index{|neighbour| neighbour.to_s != self.to_s}
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

end

class Grid
  def initialize(width, height)
    @user_sign = ["*", "+"]
    @cells = Array.new(width * height).map { Cell.new }
    @grid = @cells.each_slice(width).to_a
    @gameover = false

    @width = width
    @height = height

    assign_cell_neighbours
  end

  def gameover?
    @gameover
  end

  def update(move, user_index)
    x, y = move
    cell = @grid.dig(x,y)
    cell.place(@user_sign[user_index])
    @gameover = cell.win?
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
                     neighbour_column_index >= @height
            neighbours << @grid.dig(neighbour_row_index, neighbour_column_index)
          end
          cell[dir] = neighbours
        end
      end
    end
  end
end

class Game
  def initialize(width=15, height=15)
    @width = width
    @height = height
    @users = ["A", "B"]
    @user_index = 0
    @user = @users[@user_index]
  end

  def reset
    @grid = Grid.new(@width, @height)
  end

  def start
    reset
    puts @grid
    until @grid.gameover?
      print "Now for user<#{@user}>, Enter your move:"
      move = gets.chomp.split.map(&:to_i)
      @grid.update(move, @user_index)
      switch_user
      puts @grid
    end
  end

  def switch_user
    @user_index = (@user_index + 1) % @users.length
    @user = @users[@user_index]
  end
end

game = Game.new()
game.start
