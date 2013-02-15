require 'knight'
require 'minitest/autorun'
module Chess

  class KnightTester < MiniTest::Unit::TestCase
    puts "KnightPieceTester"
    def test_initialize
      game_board = Board.new
      n = Knight.new(1, 2, :white, game_board)
      assert_equal(1, n.row)
      assert_equal(2, n.column)
      assert_equal(:white, n.player)
      assert_equal(game_board, n.board)
      assert_equal(n, n.board[1,2])
      assert_equal([[-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2]], n.vector_moves)
    end

    def test_range
      game_board = Board.new
      n = Knight.new(5, 5, :black, game_board)
      assert_equal([[3, 4], [3, 6], [4, 7], [6, 7], [7, 6], [7, 4], [6, 3], [4, 3]], n.range)

      n = Knight.new(1, 1, :white, game_board)
      assert_equal([[0, 3], [2, 3], [3, 2], [3, 0]], n.range)
    end
  end
end