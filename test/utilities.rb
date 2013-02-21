# this file defines additional methods for Chess::Board and Chess::Piece, in order to provide less complicated tests

module Chess
  class Board
    attr_accessor :field

    def same_as?(other)
      return false unless other.is_a? Board
      0.upto(7).all? do |row|
        0.upto(7).all? do |column|
          self[row, column] == other[row, column] or
            self[row, column].same_as? other[row, column]
        end
      end
    end
  end

  class Piece
    attr_accessor :row, :column, :player, :board, :vector_moves

    def same_as?(other)
      return false unless other.is_a? Piece
      self.class == other.class and @player == other.player and
        @row == other.row and @column == other.column and first_move? == other.first_move?
    end
  end
end