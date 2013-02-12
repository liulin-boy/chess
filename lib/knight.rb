require 'piece'

module Chess
  class Knight < Piece
    attr_accessor :vector_moves

    def initialize(row, column, color, board)
      super
      @vector_moves = [[-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2]]
    end

    def sign
      @color == :white ? "N".yellow.bold : "N".red.bold
    end
  end
end