#require 'board'
require 'errors'

module Chess
  class Piece
    def initialize(row, column, player, board)
      @row, @column = row, column
      @player, @board = player, board
      @board[row, column] = self
      @vector_moves = []
    end

    def move(to_row, to_column)
      if valid_move?(to_row, to_column)
        @board[@row, @column] = nil
        @board[to_row, to_column] = self
        @row, @column = to_row, to_column
      else
        message = "#{self.class.name.split('::').last} cannot move from coords [#{@row}, #{@column}] to [#{to_row}, #{to_column}]"
        #puts message
        raise IllegalMove, message
      end
    end

    def range
      squares_in_range = []
      @vector_moves.each do |delta_row, delta_column|
        current_row = @row + delta_row
        current_column = @column + delta_column
        while current_row.between?(0, 7) and current_column.between?(0, 7)
          squares_in_range << [current_row, current_column]
          current_row = current_row + delta_row
          current_column = current_column + delta_column
        end
      end

      squares_in_range
    end

    def valid_move?(to_row, to_column)
      return false if range.none? { |row, column| row == to_row and column == to_column }
      return false if @board[to_row, to_column] and @board[to_row, to_column].player == @player
      return false if leap?(to_row, to_column)
      return false if move_causes_self_check?(to_row, to_column)

      true
    end

    def move_causes_self_check?(to_row, to_column)
      raise IllegalMove if range.none? { |row, column| row == to_row and column == to_column }
      raise IllegalMove if @board[to_row, to_column] and @board[to_row, to_column].player == @player
      raise IllegalMove if leap?(to_row, to_column)
      copy_board = @board.deep_copy

      piece = copy_board[@row, @column]
      copy_board[@row, @column] = nil
      copy_board[to_row, to_column] = piece
      piece.row, piece.column = to_row, to_column
      king = copy_board.find_king(@player)

      king and king.in_check?
    end

    def under_attack?
      @board.field.flatten.any? do |piece|
        piece and piece.player != @player and
          piece.valid_move?(@row, @column) # TO DO: use range, instead
      end
    end

    def leap?(to_row, to_column)
      if to_row < @row
        delta_row = -1
      elsif to_row > @row
        delta_row = 1
      else
        delta_row = 0
      end
      if to_column < @column
        delta_column = -1
      elsif to_column > @column
        delta_column = 1
      else
        delta_column = 0
      end
      current_row = @row + delta_row
      current_column = @column + delta_column
      while current_row != to_row or current_column != to_column
        return true if @board[current_row, current_column]
        current_row = current_row + delta_row
        current_column = current_column + delta_column
      end

      false
    end

    def first_move?
      @first_move
    end
  end
end
