require 'bishop'
require 'minitest/autorun'

module Chess
  class BishopTester < MiniTest::Unit::TestCase
    def test_initialize
      board = Board.new()
      b = Bishop.new(3, 4, :white, board)
      assert_equal 3, b.row
      assert_equal 4, b.column
      assert_equal :white, b.player
      assert_equal board, b.board
      assert_equal b, b.board[3,4]
      assert_equal [[-1, -1], [-1, 1], [1, -1], [1, 1]], b.vector_moves
    end
  end
end