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
      print_instructions
      @board.show
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

    private

    PROMOTION_PIECE = {'Q' => Queen, 'R' => Rook, 'N' => Knight, 'B' =>Bishop}

    def print_instructions
      puts "Instructions:".cyan.bold
      puts ""
      puts "To make a move, enter the coordinates of the piece you want to move, ".cyan.bold
      puts "then space, then the coordinates of the target square.".cyan.bold
      puts "Example 'e2 e4' will move a piece from e2 to e4 (if move is legal).".cyan.bold
      puts ""
      puts "To castle, enter '0-0' or '0-0-0'.".cyan.bold
      puts ""
      puts "For promotion, write the letter of the piece you want the pawn to be promoted to.".cyan.bold
      puts "Example 'a7 a8 R' will promote the pawn into a Rook (if move is legal).".cyan.bold
      puts "If no piece for the promotion is specified, it's Queen, by default.".cyan.bold
      puts ""
      puts "To resign, enter 'res' or 'resign'.".cyan.bold
      puts ""
      puts "Game started!".magenta.bold
    end

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
      if move =~ /(?<from>[a-h][1-8]) (?<to>[a-h][1-8])( )?(?<promotion>[QRNB]?)/i
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

