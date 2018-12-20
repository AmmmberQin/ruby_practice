class Cell
  RELATIVE_NEIGHBOUR_COORDINATES = {
    north: [-1, 0].freeze, north_east: [-1, 1].freeze,
    east:  [0, 1].freeze,  south_east: [1, 1].freeze,
    south: [1, 0].freeze,  south_west: [1, -1].freeze,
    west:  [0, -1].freeze, north_west: [-1, -1].freeze,
  }.freeze

  NEIGHBOUR_DIRECTIONS = RELATIVE_NEIGHBOUR_COORDINATES.keys.freeze

  attr_accessor(*NEIGHBOUR_DIRECTIONS)

  def initialize(alive = false)
    @alive = !!alive # "!!" converts alive value to boolean
  end

  def alive?
    @alive
  end

  def live!
    @alive = true
  end

  def die! # currently unused
    @alive = false
  end

  ##
  # Queues the next state. Returns true if the state is going to change and 
  # false if it stays the same.
  def queue_evolve
    @queued_alive = alive_next_cycle?

    @alive != @queued_alive
  end

  ##
  # Applies the queued state. Returns true if the state changed and false if the
  # state stayed the same.
  def apply_queued_evolve
    old_alive = @alive

    @alive = @queued_alive

    old_alive != @alive
  end

  def alive_next_cycle?
    puts neighbours
    alive_neighbours = neighbours.count(&:alive?)

    if alive?
      (2..3).cover?(alive_neighbours)
    else
      alive_neighbours == 3
    end
  end

  def going_to_change?
    alive? != alive_next_cycle?
  end

  ##
  # Used to get a neighbour in dynamic fashion. Returns the neighbouring cell or
  # nil if there is no neighbour on the provided direction.
  #
  #     cell[:north]
  #     #=> neighbouring_cell_or_nil
  #
  def [](direction)
    validate_direction(direction)
    send(direction)
  end

  ##
  # Used to set a neighbour in dynamic fashion. Returns the provided neighbour.
  #
  #     cell[:south] = other_cell 
  #     #=> other_cell
  #
  def []=(direction, neighbour)
    validate_direction(direction)
    send("#{direction}=", neighbour)
  end

  ##
  # Returns a list of all present neighbours.
  def neighbours
    NEIGHBOUR_DIRECTIONS.map(&method(:[])).compact
  end

  ##
  # Returns a hash of neighbours and their positions.
  #
  #     cell.neighbours_hash
  #     #=> {
  #       north: nil,
  #       north_east: nil,
  #       east: some_cell,
  #       south_east: some_other_cell,
  #       # ...
  #     }
  #
  def neighbours_hash # currently unused
    NEIGHBOUR_DIRECTIONS.map { |dir| [dir, self[dir]] }.to_h
  end

  ##
  # Returns "x" if the cell is alive and "." if the cell is not.
  def to_s
    alive? ? 'x' : '.'
  end

  ##
  # Since neighbours point to each other the default inspect results in an
  # endless loop. Therefore this is overwritten with a simpler representation.
  #
  #     #<Cell dead> or #<Cell alive>
  #
  def inspect
    "#<#{self.class} #{alive? ? 'alive' : 'dead'}>"
  end

  private

  def validate_direction(direction)
    unless NEIGHBOUR_DIRECTIONS.map(&:to_s).include?(direction.to_s)
      raise "unsupported direction #{direction}"
    end
  end
end

class Grid
  def initialize(width, height, seeds = [])
    @cells = Array.new(width * height).map { Cell.new }
    @grid  = @cells.each_slice(width).to_a

    seeds.each { |coordinate| @grid.dig(*coordinate).live! }

    assign_cell_neighbours
  end

  ##
  # Returns true if the resulting grid changed after evolution.
  def evolve
    # Keep in mind that any? short circuits after the first truethy evaluation.
    # Therefore the following line would yield incorrect results.
    #
    #     @cells.each(&:queue_evolve).any?(&:apply_queued_evolve)
    #

    @cells.each(&:queue_evolve).map(&:apply_queued_evolve).any?
  end

  ##
  # Returns true if the next evolutions doesn't change anything.
  def lifeless?
    @cells.none?(&:going_to_change?)
  end

  ##
  # Returns the grid in string format. Placing an "x" if a cell is alive and "."
  # if a cell is dead. Rows are separated with newline characters.
  def to_s
    @grid.map { |row| row.map(&:to_s).join }.join("\n")
  end

  private

  ##
  # Assigns every cell its neighbours. @grid must be initialized.
  def assign_cell_neighbours
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        Cell::RELATIVE_NEIGHBOUR_COORDINATES.each do |dir, rel_coord|
          (rel_row_index, rel_column_index) = rel_coord
          neighbour_row_index    = row_index    + rel_row_index
          neighbour_column_index = column_index + rel_column_index

          next if neighbour_row_index.negative? || 
                  neighbour_column_index.negative?

          cell[dir] = @grid.dig(neighbour_row_index, neighbour_column_index)
        end
      end
    end
  end
end

class Game
  def initialize(width, height, seeds)
    @width  = width
    @height = height
    @seeds  = seeds
  end

  def reset
    @grid = Grid.new(@width, @height, @seeds)
  end

  def start
    reset

    puts @grid

    until @grid.lifeless?
      @grid.evolve

      puts
      puts @grid
    end
  end
end

game = Game.new(5, 5, [[0,2], [1,0], [1,2], [2,1], [2,2]])
game.start