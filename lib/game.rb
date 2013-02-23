$:.unshift('chess/lib')
require 'board'

module Chess
  class Game
    def initialize(board = Board.new.reset, first_to_move = :white)
      @board = board
      @current_player = first_to_move
    end

    def play
      @current_player = :white
      @board.show
      puts "Game started!".magenta.bold
      loop do
        break if end_of_game?
          determine_check(@current_player)
          puts "#{@current_player}'s turn:".green.bold
        begin
          move = read_move
          if(execute_move(move, @current_player))
            change_player
          end
        rescue
          puts "IllegalMove".red.bold
        end
        @board.show
      end
    end

    def to_string
      @board.to_string
    end

    def save_to_database(mysql2_client, table_name)
      @board.save_to_database(mysql2_client, table_name)
    end

    def self.load_from_string(str)
      board = Board.load_from_string(str)

      new(board)
    end

    def self.load_from_database(mysql2_client, table_name)
      board = Board.load_from_database(mysql2_client, table_name)

      new(board)
    end

    PROMOTION_PIECE = {'Q' => Queen, 'R' => Rook, 'N' => Knight, 'B' =>Bishop}

    def change_player
      if @current_player == :white
        @current_player = :black
      else
        @current_player = :white
      end
    end

    def determine_check(player)
      if @board.find_king(player).in_check?
        puts "Check!".red.bold
      end
    end

    def read_move
      gets.chomp
    end

    def execute_move(move, player)
      if move =~ /(?<from>[a-h][1-8]) (?<to>[a-h][1-8])(?<promotion>[QRNB]?)/i
        if $~[:promotion] == ""
          @board.execute_move($~[:from], $~[:to], player)
        else
          promotion = PROMOTION_PIECE[$~[:promotion]]
          @board.execute_move($~[:from], $~[:to], player, promotion)
        end
      elsif move =~ /0-0-0/
        @board.queenside_castle(player)
      elsif move =~ /0-0/
        @board.kingside_castle(player)
      elsif move =~ /res(ign)?/i
        if player == :white
          @winner = :black
        else
          @winner = :white
        end

        true
      else
        puts "Invalid input!".red.bold

        false
      end
    end

    def end_of_game?
      if @board.find_king(@current_player).in_checkmate?
        puts "Checkmate!".red.bold
        puts "#{other_player(@current_player)}s WIN!".magenta.bold

        true
      elsif @board.find_king(@current_player).in_stalemate?
        puts "Stalemate!".red.bold
        puts "DRAW!".magenta.bold

        true
      elsif @winner
        puts "#{other_player(@winner)}s resigned!".red.bold
        puts "#{@winner}s WIN!".magenta.bold

        true
      else
        false
      end
    end

    def other_player(player)
      if player == :white
        :black
      else
        :white
      end
    end
  end
end

