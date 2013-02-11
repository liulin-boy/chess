$:.unshift('D:/Program Files/Ruby/Ruby193/bin/chess/lib')
puts $:

module Chess
  class Board
    attr_accessor :field

    def initialize()
      @field = Array.new(8) { Array.new(8) }
    end

    def [](column, row)
      @field[column][row]
    end

    def []=(column, row, piece)
      @field[column][row] = piece
    end

    def white_king
      find_king(:white)
    end

    def white_king
      find_king(:black)
    end

    def deep_copy
      new_board = Board.new
      @field.each_with_index do |row, r_index|
        row.each_with_index do |column, c_index|
          piece = @field[r_index][c_index]
          if piece
            copy = piece.class.new(r_index, c_index, piece.color, new_board)
            new_board[r_index, c_index] = copy
          end
        end
      end

      new_board
    end

    # TO DO: ? private

    def find_king(color)
      @field.flatten.find { |piece| piece and piece.is_a?(King) and piece.color == color }
    end
  end
end

