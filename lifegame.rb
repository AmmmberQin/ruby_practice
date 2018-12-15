class Game
    WIDTH = 5
    HEIGHT = 5
    SEEDS = [[0,2],[1,0],[1,2],[2,1],[2,2]]

    def initialize
        @grid = Grid.new(WIDTH, HEIGHT)
        @grid.plant_seeds(SEEDS)
    end

    def start
        while not @grid.lifeless?
            puts @grid
            next_grid = update()
            if(@grid == next_grid)
                break
            end
            @grid = next_grid
        end
    end

    def update
        next_round = Grid.new(WIDTH, HEIGHT)
        0.upto(WIDTH-1) do |row|
            0.upto(HEIGHT-1) do |column|
                next_round.update(row, column, evolve(row, column))
            end
        end
        return next_round
    end

    def evolve(row, column)
        directions = [[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]]
        t = 0
        directions.each do |i, j|
            if (row+i >= 0 and row+i < WIDTH and column+j >= 0 and column+j < HEIGHT)
                if(@grid.cell_alive(row+i,column+j))
                    t += 1
                end
            end
        end

        return ((@grid.cell_alive(row,column) and (t == 2 or t == 3)) or (not @grid.cell_alive(row,column) and t == 3))
    end

end

class Grid
    def initialize(width, height)
        @width = width
        @height = height
        @grid = setup_grid
    end

    def setup_grid
        grid = []
        @width.times do |row|
            cells = []
            @height.times do |column|
                cells << Cell.new(false)
            end
            grid << cells
        end
        return grid
    end

    def plant_seeds(seeds)
        seeds.each do |x,y|
            @grid[x][y].live!
        end
    end

    def update(row, column, value)
        @grid[row][column].change_state(value)
    end

    def cell_alive(row, column)
        return @grid[row][column].alive?
    end

    def lifeless?
        not @grid.any?{|row| row.any?{|cell| cell.alive?}}
    end

    def to_s
        rows = []
        0.upto(@width-1) do |row|
            columns = []
            0.upto(@height-1) do |column|
                columns << @grid[row][column].to_s
            end
            rows << columns.join("")
        end
        return rows.join("\n") + "\n\n"
    end

    def ==(other)
        0.upto(@width-1) do |row|
            0.upto(@height-1) do |column|
                if cell_alive(row, column) != other.cell_alive(row, column)
                    return false
                end
            end
        end
        return true
    end

end

class Cell
    def initialize(alive)
        @alive = alive
    end

    def change_state(state)
        @alive = state
    end

    def alive?
        @alive
    end

    def live!
        @alive = true
    end

    def to_s
        if @alive
            return "x"
        else
            return "."
        end
    end

end

game = Game.new()
game.start()