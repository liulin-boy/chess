require 'piece'

module Chess
  class King < Piece
    def initialize(row, column, player, board, first_move = true)
      super
      @first_move = first_move
      @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    end

    def in_check?
      under_attack?
    end

    def in_checkmate?
      in_check? and player_has_no_valid_moves?
    end

    def in_stalemate?
      not in_check? and player_has_no_valid_moves?
    end

    def sign
      @player == :white ? "K".yellow.bold : "K".red.bold
    end

    private

    def range
      @vector_moves.map { |delta_row, delta_column| [@row + delta_row, @column + delta_column]}.
        select { |row, column| row.between?(0, 7) and column.between?(0, 7) }
    end

    def player_has_no_valid_moves?
      @board.field.flatten.select { |piece| piece and piece.player == @player}.all? do |piece|
        piece.range.all? do |to_row, to_column|
          !piece.valid_move?(to_row, to_column)
        end
      end
    end
  end
end

