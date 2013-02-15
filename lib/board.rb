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
    COLUMN_HASH = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7}
    ROW_HASH    = {'8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7}
    PIECE_HASH  = {'K' => King, 'Q' => Queen, 'R' => Rook, 'N' => Knight, 'B' => Bishop, 'P' => Pawn}
    PLAYER_HASH = {'w' => :white, 'b' => :black}

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

    def deep_copy
      new_board = Board.new
      @field.each_with_index do |row, r_index|
        row.each_with_index do |column, c_index|
          piece = @field[r_index][c_index]
          if piece
            copy_piece = piece.class.new(piece.row, piece.column, piece.player, new_board)
            new_board[r_index, c_index] = copy_piece
          end
        end
      end

      new_board
    end

    def find_king(player)
      @field.flatten.find { |piece| piece and piece.is_a?(King) and piece.player == player }
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

    def make_move(from_square, to_square, player)
      from_row = ROW_HASH[from_square[1]]
      from_column = COLUMN_HASH[from_square[0].downcase]
      to_row = ROW_HASH[to_square[1]]
      to_column = COLUMN_HASH[to_square[0].downcase]


      if self[from_row, from_column].player != player
        piece_type = self[from_row, from_column].class.name.split('::').last
        puts "Illegal move!: #{piece_type} on #{from_square} does not belong to #{player}s".red.bold
        return false
      end
      self[from_row, from_column].move(to_row, to_column)

      true
    rescue IllegalMove => ex
      piece_type = self[from_row, from_column].class.name.split('::').last
      puts "Illegal move!: #{piece_type} from #{from_square} to #{to_square}".red.bold

      false
    end

    def self.load_from_string(str)
      board = Board.new
      str.split.each do |item|
        player = PLAYER_HASH[item[0]]
        piece_type = PIECE_HASH[item[1].capitalize]
        column = COLUMN_HASH[item[2]]
        row = ROW_HASH[item[3]]
        p item, row, column, player, piece_type
        if board[row, column]
          puts "Invalid string. Two or more pieces on same position".red.bold
          return
        else
          piece_type.new(row, column, player, board)
        end
      end
      board
    rescue
      puts "Invalid string!".red.bold
    end
  end
end


