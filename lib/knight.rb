require 'piece'

module Chess
  class Knight < Piece
    def initialize(row, column, player, board)
      super
      @vector_moves = [[-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2]]
    end

    def leap?(to_row, to_column)
      false
    end

    def range
      @vector_moves.map { |delta_row, delta_column|  [@row + delta_row, @column + delta_column]}.
        select { |row, column| row.between?(0, 7) and column.between?(0, 7) }
    end

    def sign
      @player == :white ? "N".yellow.bold : "N".red.bold
    end
  end
end