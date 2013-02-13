require_relative 'piece'

module Chess
  class King < Piece
    attr_accessor :vector_moves, :first_move

    def initialize(row, column, color, board)
      super
      @first_move = true # for castling
      @vector_moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]] # TO DO: add castling
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
      @board.field.flatten.select { |piece| piece and piece.color == @color}.all? do |piece|
        piece.range.all? do |to_row, to_column|
          !piece.valid_move?(to_row, to_column) or
            piece.move_causes_self_check?(to_row, to_column) # TO DO: shouldnt get away from checkmate with castling
        end
      end
    end

    def range
      @vector_moves.map { |delta_row, delta_column|  [@row + delta_row, @column + delta_column]}.
        select { |row, column| row.between?(0, 7) and column.between?(0, 7) }
    end

    def sign
      @color == :white ? "K".yellow.bold : "K".red.bold
    end

  end
end

