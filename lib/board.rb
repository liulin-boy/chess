$:.unshift('chess/lib')

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
    COLUMN        = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7}
    ROW           = {'8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7}
    PIECE         = {'K' => King, 'Q' => Queen, 'R' => Rook, 'N' => Knight, 'B' => Bishop, 'P' => Pawn}
    PLAYER        = {'w' => :white, 'b' => :black}
    FILE          = COLUMN.invert
    RANK          = ROW.invert
    PIECE_LETTER  = PIECE.invert
    PLAYER_LETTER = PLAYER.invert

    def initialize
      @field = Array.new(8) { Array.new(8) }
    end

    def [](row, column)
      @field[row][column]
    end

    def []=(row, column, value)
      @field[row][column] = value
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
        print "#{1.upto(8).to_a.reverse[i]} |"
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

      self # because it's cool
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
      from_row = ROW[from_square[1]]
      from_column = COLUMN[from_square[0].downcase]
      to_row = ROW[to_square[1]]
      to_column = COLUMN[to_square[0].downcase]
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
        player = PLAYER[item[0]]
        piece_type = PIECE[item[1].capitalize]
        column = COLUMN[item[2]]
        row = ROW[item[3]]
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

    def to_string
      @field.flatten.select{ |piece| piece }.map do |piece|
        player_letter = PLAYER_LETTER[piece.player]
        piece_letter = PIECE_LETTER[piece.class]
        file = FILE[piece.column]
        rank = RANK[piece.row]
        "#{player_letter}#{piece_letter}#{file}#{rank}"
      end.join ' '
    end

    # i'm using mysql2 gem
    def save_to_database(db, table_name)
      query_string =
        "CREATE  TABLE `ruby`.`#{table_name}`
        (`id` INT NOT NULL ,
        `player` VARCHAR(10) NULL ,
        `piece_type` VARCHAR(10) NULL ,
        `file` CHAR NULL , `rank` INT NULL ,
        `first_move` BINARY NULL ,
        PRIMARY KEY (`id`) );"
      db.query(query_string)
      current_id = 1
      @field.flatten.select{ |piece| piece }.map do |piece|
        piece_type = piece.class.name.split('::').last
        player = piece.player
        file = FILE[piece.column]
        rank = RANK[piece.row]
        first_move = !!piece.first_move?

        query_string = "INSERT INTO #{table_name} (id, piece_type, player, file, rank, first_move)
          VALUES(#{current_id}, '#{piece_type}', '#{player}', '#{file}', #{rank}, #{first_move} );"
        db.query(query_string)
        current_id = current_id.next
      end
    end
  end
end


