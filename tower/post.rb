#!/usr/bin/ruby
require 'gosu'
class Post
    def initialize(window, x, y, width=40, height=400)
        @height = height
        @width = width
        @x = x
        @y = y
        @color = Gosu::Color.argb(0xaa0000ff)
        @window = window
        @discs = []
    end

    def draw
        @window.draw_quad(
            @x, @y, @color,
            @x + @width, @y, @color,
            @x + @width, @y + @height, @color,
            @x, @y + @height, @color)
    end

    def add_disc(disc)
        @discs.push(disc)
        disc.post = self
    end

    def remove_disc(disc)
        @disc.delete(disc)
        disc.post = nil
    end

    def last
        @disc.last
    end

    def find_disc_position(disc)
        @discs.find_index(disc)
    end

    def sort_discs
        @discs.sort_by!{|disc| -disc.number}
    end

    def valid_move?(disc)
        disc.top_most? && (@discs.empty? || disc.number < last.number)
    end

    def move_disc(disc)
        disc.post.remove_disc(disc)
        add_disc(disc)
    end

    def contains?(mouse_x, mouse_y)
        mouse_x >= @x && mouse_x <= @x + @width && mouse_y >= @y && mouse_y <= @y + @height
    end

    def center
        @x + (@width / 2)
    end

    def base
        @y + @height
    end


end
