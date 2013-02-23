# this file defines additional methods for Chess::Game, Chess::Board, Chess::Piece, Chess::King,
# Chess::Pawn and Chess::Knight, in order to provide less complicated tests

module Chess
  class Game
    attr_accessor :board, :current_player
  end

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
    attr_accessor :vector_moves

    public :valid_move?, :range, :move_causes_self_check?, :leap?, :under_attack?

    def same_as?(other)
      return false unless other.is_a? Piece
      self.class == other.class and @player == other.player and
        @row == other.row and @column == other.column and first_move? == other.first_move?
    end
  end

  class King
    public :range
  end

  class Pawn
    public :valid_move?, :range
  end

  class Knight
    public :leap?, :range
  end
end