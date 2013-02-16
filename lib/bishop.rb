require_relative 'piece'

module Chess
  class Bishop < Piece
    def initialize(row, column, player, board)
      super
      @vector_moves = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    end

    def sign
      @player == :white ? "B".yellow.bold : "B".red.bold
    end
  end
end