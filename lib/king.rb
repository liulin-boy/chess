require 'piece'

module Chess
  class King < Piece
    def initialize(row, column, player, board)
      super
      @first_move = true
      @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    end

    def move(to_row, to_column)
      super
      @first_move = false
    end

    def in_check?
      under_attack?
    end

    def in_checkmate?
      return false unless in_check?
      @board.field.flatten.select { |piece| piece and piece.player == @player}.all? do |piece|
        piece.range.all? do |to_row, to_column|
          !piece.valid_move?(to_row, to_column) or
            piece.move_causes_self_check?(to_row, to_column)
        end
      end
    end

    def range
      @vector_moves.map { |delta_row, delta_column|  [@row + delta_row, @column + delta_column]}.
        select { |row, column| row.between?(0, 7) and column.between?(0, 7) }
    end

    def sign
      @player == :white ? "K".yellow.bold : "K".red.bold
    end

  end
end

