require 'king'
require 'bishop'
require 'minitest/autorun'

module Chess
  class KingTester < MiniTest::Unit::TestCase
    def test_initialize
      board = Board.new
      k = King.new(1, 2, :white, board)
      assert_equal 1, k.row
      assert_equal 2, k.column
      assert_equal :white, k.player
      assert_equal board, k.board
      assert_equal k, k.board[1,2]
      assert k.first_move?
      assert_equal [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]], k.vector_moves
    end

    def test_range
      board = Board.new
      k = King.new(0, 1, :white, board)
      assert_equal [[0, 0], [0, 2], [1, 0], [1, 1], [1, 2]], k.range
    end

    def test_move
      board = Board.new
      k = King.new(0, 1, :white, board)
      assert_raises(IllegalMove) { k.move(1, 3) }

      k.move(1, 2)
      assert_equal nil, board[0, 1]
      assert_equal k, board[1, 2]
      assert_equal 1, k.row
      assert_equal 2, k.column
      assert !k.first_move?
    end

    def test_in_check?
      board = Board.new
      k = King.new(1, 2, :white, board)
      assert !k.in_check?
      b = Bishop.new(5, 6, :black, board)
      assert k.in_check?
      b = Bishop.new(3, 4, :white, board)
      assert !k.in_check?
    end

    def test_in_checkmate?
      board = Board.new
      k = King.new(0, 0, :white, board)
      q = Queen.new(1, 1, :black, board)
      assert !k.in_checkmate?
      b1 = Bishop.new(3, 3, :black, board)
      assert k.in_checkmate?
      b2 = Bishop.new(0, 2, :white, board)
      assert !k.in_checkmate?
    end

    def test_in_stalemate?
      board = Board.new
      k = King.new(0, 0, :white, board)
      r = Rook.new(1, 1, :black, board)
      assert !k.in_stalemate?
      b1 = Bishop.new(3, 3, :black, board)
      assert k.in_stalemate?
      b2 = Bishop.new(7, 7, :white, board)
      assert !k.in_stalemate?
    end
  end
end