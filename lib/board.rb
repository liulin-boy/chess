$:.unshift('D:/Program Files/Ruby/Ruby193/bin/chess/lib')

require 'string_formatting'
require 'game'
require 'king'
require 'queen'
require 'rook'
require 'bishop'
require 'knight'
require 'pawn'

module Chess
  class Board
    attr_accessor :field

    def initialize()
      @field = Array.new(8) { Array.new(8) }
    end

    def [](row, column)
      @field[row][column]
    end

    def []=(row, column, piece)
      @field[row][column] = piece
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

      self
    end

    COLUMN_HASH = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7}
    ROW_HASH    = {'8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7}

    def move(from_square, to_square) # TO DO: ? specify player
      from_row = ROW_HASH[from_square[1]]
      from_column = COLUMN_HASH[from_square[0]]
      to_row = ROW_HASH[to_square[1]]
      to_column = COLUMN_HASH[to_square[0]]
      self[from_row, from_column].move(to_row, to_column)

      true
    rescue IllegalMove => ex
      piece_type = self[from_row, from_column].class.name.split('::').last
      puts "Illegal move!: #{piece_type} from #{from_square} to #{to_square}".red.bold

      false
    end

  end
end


