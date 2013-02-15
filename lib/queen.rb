require 'piece'

module Chess
  class Queen < Piece
    attr_accessor :vector_moves

    def initialize(row, column, player, board)
      super
      @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    end

    def sign
      @player == :white ? "Q".yellow.bold : "Q".red.bold
    end
  end
end