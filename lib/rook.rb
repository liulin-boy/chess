require 'piece'

module Chess
  class Rook < Piece
    def initialize(row, column, player, board, first_move = true)
      super
      @vector_moves = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    end

    def castle
      king = @board.find_king(@player)
			raise IllegalMove unless first_move? and king.first_move?
      raise IllegalMove if king.in_check?
      if @column == 0 # 0-0-0
        raise IllegalMove if king.move_causes_self_check?(king.row, 3) or
          @board[@row, 1] or @board[@row, 2] or @board[@row, 3]
        king.column = 2
        if king.in_check?
          king.column = 4
          raise IllegalMove
        end
        @board[king.row, 4] = nil
        @board[king.row, 2] = king
        @board[@row, 0] = nil
        @board[@row, 3] = self
        @column = 3

        true
      else # 0-0
        raise IllegalMove if king.move_causes_self_check?(king.row, 5) or @board[@row, 5] or @board[@row, 6]
        king.column = 6
        if king.in_check?
          king.column = 4
          raise IllegalMove
        end
        @board[king.row, 4] = nil
        @board[king.row, 6] = king
        @board[@row, 7] = nil
        @board[@row, 5] = self
        @column = 5
      end
      @first_move = false
      king.instance_variable_set(:@first_move, false)

      true
		end

    def sign
      @player == :white ? "R".yellow.bold : "R".red.bold
    end
  end
end