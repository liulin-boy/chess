require_relative 'piece'

module Chess
  class Bishop < Piece
    attr_accessor :vector_moves

    def initialize(row, column, color, board)
      super
      @vector_moves = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    end
  end
end