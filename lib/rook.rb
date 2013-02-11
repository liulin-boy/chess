require 'piece'

module Chess
  class Rook < Piece
    attr_accessor :vector_moves

    def initialize(row, column, color, board)
      super
      @first_move = true
      @vector_moves = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    end

    def move(to_row, to_column)
      super
      @first_move = false
    end
  end
end