class Game
    def initialize(width, height, seeds)
        @width = width
        @height = height
        @seeds = seeds
    end

    def reset
        @grid = Grid.new(@width, @height, @seeds)
    end

    def start
        reset
        until @grid.lifeless?
            puts @grid
            puts

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
    def initialize(width, height, seeds=[])
        @cells = Array.new(width * height).map{ Cell.new}
        @grid = @cells.each_slice(width).to_a

        seeds.each{|coordinate| @grid.dig(*coordinate).live!}
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
        @cell.none?(&:going_to_change?)
    end

    def to_s
        @grid.map{|row| row.map(&:to_s).join}.join("\n")
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
    def initialize(alive=false)
        @alive = !!alive
    end

    def alive_next_cycle?
        alive_neighbors = neighbor.count(&:alive?)

        if alive?


    def going_to_change?
        alive? != alive_next_cycle?
    end

    def alive?
        @alive
    end

    def live!
        @alive = true
    end

    def to_s
        alive?? 'x' : '.'
    end

end

width = 5
height = 5
seeds = [[0,2],[1,0],[1,2],[2,1],[2,2]]

game = Game.new()
game.start()