require 'piece'

module Chess
  class Rook < Piece
    def initialize(row, column, player, board)
      super
      @first_move = true
      @vector_moves = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    end

    def move(to_row, to_column)
      super
      @first_move = false
    end

    def castle
      king = @board.find_king(@player)
			raise(IllegalMove, "Cannot castle, Rook alredy moved") unless @first_move
      raise(IllegalMove, "Cannot castle, Rook alredy moved") unless king.first_move?
      raise(IllegalMove, "Cannot castle, King is in check") if king.in_check?

      if @column == 0 # 0-0-0
        raise(IllegalMove, "Cannot castle, path is blocked") if @board[@row, 1] or @board[@row, 2] or @board[@row, 3]
        raise(IllegalMove, "Cannot castle, King passes through attacked square") if king.move_causes_self_check?(king.row, 3)
        king.column = 2
        if king.in_check?
          king.column = 4
          raise(IllegalMove, "Cannot castle, King will be in check")
        end
        @board[king.row, 4] = nil
        @board[king.row, 2] = king
        @board[@row, 0] = nil
        @board[@row, 3] = self
        @column = 3
      else # 0-0
        raise(IllegalMove, "Cannot castle, path is blocked") if @board[@row, 5] or @board[@row, 6]
        raise(IllegalMove, "Cannot castle, King passes through attacked square") if king.move_causes_self_check?(king.row, 5)
        king.column = 6
        if king.in_check?
          king.column = 4
          raise(IllegalMove, "Cannot castle, King will be in check")
        end
        @board[king.row, 4] = nil
        @board[king.row, 6] = king
        @board[@row, 7] = nil
        @board[@row, 5] = self
        @column = 5
      end
      @first_move = false
      king.instance_variable_set(:@first_move, false)
		end

    def sign
      @player == :white ? "R".yellow.bold : "R".red.bold
    end
  end
end