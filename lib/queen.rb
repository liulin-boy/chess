﻿require 'piece'

module Chess
  class Queen < Piece
    attr_accessor :vector_moves

    def initialize(row, column, color, board)
      super
      @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]]
    end
  end
end