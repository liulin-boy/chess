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
    FIRST_ROW_PIECES = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    ALL_PIECES       = [King, Queen, Rook, Knight, Bishop, Pawn]
    ALL_PLAYERS      = [:white, :black]
    COLUMN           = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7}
    ROW              = {'8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7}
    FILE             = COLUMN.invert
    RANK             = ROW.invert

    def initialize
      @field = Array.new(8) { Array.new(8) }
    end

    def [](row, column)
      @field[row][column]
    end

    def []=(row, column, value)
      @field[row][column] = value
    end

    def find_king(player)
      @field.flatten.find { |piece| piece and piece.is_a?(King) and piece.player == player }
    end

    def make_move(from_square, to_square, player)
      from_row = ROW[from_square[1]]
      from_column = COLUMN[from_square[0].downcase]
      to_row = ROW[to_square[1]]
      to_column = COLUMN[to_square[0].downcase]
      if self[from_row, from_column].player != player
        piece_type = self[from_row, from_column].class.name.split('::').last
        raise IllegalMove, "Piece on #{from_square} does not belong to #{player} player!".red.bold
      end
      begin
        self[from_row, from_column].move(to_row, to_column)
      rescue IllegalMove
        piece_type = self[from_row, from_column].class.name.split('::').last
        raise IllegalMove, "Cannot move #{piece_type} from #{from_square} to #{to_square}!".red.bold
      end

      true
    end

    def queenside_castle(player)
      if player == :white
        self[7, 0].castle
      else
        self[0, 0].castle
      end
    end

    def kingside_castle(player)
      if player == :white
        self[7, 7].castle
      else
        self[0, 7].castle
      end
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

      self # just because it's cool
    end

    def reset
      @field = Array.new(8) { Array.new(8) }
      0.upto(7).each do |column|
        Pawn.new(1, column, :black, self)
        Pawn.new(6, column, :white, self)
      end
      FIRST_ROW_PIECES.each_with_index do |piece_type, column|
        piece_type.new(0, column, :black, self)
        piece_type.new(7, column, :white, self)
      end

      self
    end

    def to_string
      @field.flatten.select{ |piece| piece }.map do |piece|
        piece_type = piece.class.name.split('::').last
        player = piece.player.to_s
        file = FILE[piece.column]
        rank = RANK[piece.row]
        move_status = piece.first_move? ? "" : " moved"

        "#{player} #{piece_type} #{file}#{rank}#{move_status};"
      end.join ' '
    end

    def save_to_database(mysql2_client, table_name)
      create_table =
        "CREATE  TABLE `#{mysql2_client.query_options[:database]}`.`#{table_name}`(
          `id` INT NOT NULL ,
          `player` VARCHAR(10) NULL ,
          `piece_type` VARCHAR(10) NULL ,
          `file` CHAR NULL , `rank` INT NULL ,
          `first_move` BINARY NULL ,
          PRIMARY KEY (`id`)
        );"
      mysql2_client.query(create_table)
      current_id = 1
      @field.flatten.select{ |piece| piece }.map do |piece|
        piece_type = piece.class.name.split('::').last
        player = piece.player
        file = FILE[piece.column]
        rank = RANK[piece.row]
        first_move = piece.first_move?
        insert =
          "INSERT INTO #{table_name}(id, piece_type, player, file, rank, first_move)
          VALUES(#{current_id}, '#{piece_type}', '#{player}', '#{file}', #{rank}, #{first_move} );"
        mysql2_client.query(insert)
        current_id = current_id.next
      end
    end

    def self.load_from_string(str)
      board = Board.new
      str.split(';').each do |item|
        /\A((?<player>\w*) (?<piece_type>\w*) (?<file>[a-h])(?<rank>[1-8])(?<move_status>( moved)?))\z/ =~ item.strip
        player = $~[:player].to_sym
        piece_type = eval($~[:piece_type])
        row = ROW[$~[:rank]]
        column = COLUMN[$~[:file]]
        first_move = $~[:move_status] == ""
        if not ALL_PLAYERS.include?(player) or not ALL_PIECES.include?(piece_type) or row.nil? or column.nil?
          raise
        else
          piece_type.new(row, column, player, board, first_move)
        end
      end

      board
    rescue
      raise "Invalid string to load from! - '#{str}'".red.bold
end

    def self.load_from_database(mysql2_client, table_name)
      board = Board.new
      matching_tables =
        "SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = '#{mysql2_client.query_options[:database]}'
        AND table_name = '#{table_name}';"
      if mysql2_client.query(matching_tables).size.zero?
        raise "No such table (#{table_name})!".red.bold
      end
      results = mysql2_client.query("SELECT * FROM #{table_name}")
      results.each do |item|
        piece_type = eval(item["piece_type"])
        row        = ROW[item["rank"].to_s] # TO DO: data validation
        column     = COLUMN[item["file"]]
        player     = item["player"].to_sym

        if item["first_move"] == "1"
          first_move = true
        elsif item["first_move"] == "0"
          first_move = true
        else
          raise
        end
        if not ALL_PLAYERS.include?(player) or not ALL_PIECES.include?(piece_type) or row.nil? or column.nil?
          raise
        else
          piece_type.new(row, column, player, board, first_move)
        end
      end

      board
    rescue
      raise "Invalid table to load from! - '#{table_name}'".red.bold
    end
  end
end


