#!/usr/bin/ruby

# simple print shape
# how to play, just run `ruby shape.rb` on command

puts "Welcome to Shapes"
print "How big do you want your shape? "
shape_size = gets.to_i
print "Outside letter: "
outside_letter = gets
outside_letter = outside_letter.chomp
print "Inside letter: "
inside_letter = gets
inside_letter = inside_letter.chomp
puts "About to draw a shape #{shape_size} big"
puts "using #{outside_letter} for the edge"
puts "and #{inside_letter} for the inside"


height = shape_size
width = shape_size * 2



def rectangle(height, width, outside_letter, inside_letter)
    1.upto(height) do |row|
        if row == 1
            puts outside_letter * width
        elsif row == height
            puts outside_letter * width
        else
            middle = inside_letter * (width - 2)
            puts "#{outside_letter}#{middle}#{outside_letter}"
        end
    end
end

def triangle(height, outside_letter, inside_letter)
    1.upto(height) do |row|
        print ' ' * (height - row)
        if row == 1
            puts "#{outside_letter * 2}"
        elsif row == height
            puts outside_letter * height * 2
        else
            middle = inside_letter * (row - 2)
            print "#{outside_letter}#{middle}#{inside_letter}"
            puts "#{inside_letter}#{middle}#{outside_letter}"  
        end
    end
end

triangle(height, outside_letter, inside_letter)
rectangle(height, width, outside_letter, inside_letter)
