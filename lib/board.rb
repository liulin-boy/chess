$:.unshift('D:/Program Files/Ruby/Ruby193/bin/chess/lib')

require 'king'
require 'queen'
require 'rook'
require 'bishop'
require 'knight'
require 'pawn'

require 'win32console'
class String
  { :reset          =>  0,
    :bold           =>  1,
    :dark           =>  2,
    :underline      =>  4,
    :blink          =>  5,
    :negative       =>  7,
    :black          => 30,
    :red            => 31,
    :green          => 32,
    :yellow         => 33,
    :blue           => 34,
    :magenta        => 35,
    :cyan           => 36,
    :white          => 37,
    :white_back     => 47,
  }.each do |key, value|
    define_method key do
      "\e[#{value}m" + self + "\e[0m"
    end
  end
end

module Chess
  class Board
    attr_accessor :field

    def initialize()
      @field = Array.new(8) { Array.new(8) }
    end

    def [](column, row)
      @field[column][row]
    end

    def []=(column, row, piece)
      @field[column][row] = piece
    end

    def white_king
      find_king(:white)
    end

    def white_king
      find_king(:black)
    end

    def deep_copy
      new_board = Board.new
      @field.each_with_index do |row, r_index|
        row.each_with_index do |column, c_index|
          piece = @field[r_index][c_index]
          if piece
            copy = piece.class.new(r_index, c_index, piece.color, new_board)
            new_board[r_index, c_index] = copy
          end
        end
      end

      new_board
    end

    # TO DO: ? private

    def find_king(color)
      @field.flatten.find { |piece| piece and piece.is_a?(King) and piece.color == color }
    end

    def show
      puts
      puts "  +---+---+---+---+---+---+---+---+"
      @field.each_with_index do |row, i|
				print "#{(1..8).to_a.reverse[i]} |"
				row.each do |piece|
					if piece
						print " #{piece.sign} |"
					else
						print "   |"
					end
				end
				puts
				puts "  +---+---+---+---+---+---+---+---+"
      end
      puts "    a   b   c   d   e   f   g   h"
    end

    def reset
      pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      @field = Array.new(8) { Array.new(8) }
      0.upto(7).each do |column|
				Pawn.new(1, column, :black, self)
				Pawn.new(6, column, :white, self)
      end
      pieces.each_with_index do |piece_type, column|
				piece_type.new(0, column, :black, self)
				piece_type.new(7, column, :white, self)
      end
      show
    end

    Board.new.reset
  end
end


