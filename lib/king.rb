require_relative 'piece'

module Chess
  class King < Piece
    attr_accessor :vector_moves, :first_move

    def initialize(row, column, color, board)
      super
      @first_move = true # for castling
      @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]] # TO DO: add castling
    end

    def move(to_row, to_column)
      super
      @first_move = false
    end

    def in_check?
      # TO DO: check if double-check :)
      under_attack?
    end

    def in_checkmate?
      return false unless in_check?

      free_adjacent = @range.select { |row, column| @board[row, column].nil?}
      #TO DO: implement using causes_self_check?

    end

    def range
      @vector_moves.map { |delta_row, delta_column|  [@row + delta_row, @column + delta_column]}.
        select { |row, column| row.between?(0, 7) and column.between?(0, 7) }
    end
  end
end

