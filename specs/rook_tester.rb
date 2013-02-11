require 'rook'
require 'minitest/autorun'
module Chess

  class RookTester < MiniTest::Unit::TestCase
    puts "RookPieceTester"
    def test_initialize
      game_board = Board.new()
      r = Rook.new(1, 2, :white, game_board)
      assert_equal(1, r.row)
      assert_equal(2, r.column)
      assert_equal(:white, r.color)
      assert_equal(game_board, r.board)
      assert_equal(r, r.board[1,2])
      assert_equal([[-1, 0], [1, 0], [0, -1], [0, 1]], r.vector_moves)
    end
  end
end