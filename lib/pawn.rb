require 'piece'

module Chess
  class Pawn < Piece
    def initialize(row, column, player, board, first_move = true)
      super
      if player == :white
        @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [-2, 0]]
      else
        @vector_moves = [[1, -1], [1, 0], [1, 1], [2, 0]]
      end
    end

    def valid_move?(to_row, to_column)
      return false if range.none? { |row, column| row == to_row and column == to_column}
      return false if (to_row - @row).abs == 2 and !@first_move
      return false if to_column == @column and @board[to_row, to_column]
      return false if (to_row - @row).abs == 2 and @board[(to_row + @row)/2, @column]
      return false if to_column != @column and
        (@board[to_row, to_column].nil? or @board[to_row, to_column].player == @player)
      return false if move_causes_self_check?(to_row, to_column)

      true
    end

    def range
      @vector_moves.map { |delta_row, delta_column|  [@row + delta_row, @column + delta_column]}.
        select { |row, column| row.between?(0, 7) and column.between?(0, 7) }
    end

    def sign
      @player == :white ? "p".yellow.bold : "p".red.bold
    end


    # TO DO: promotion, en passant
  end
end