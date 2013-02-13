require 'queen'
require 'minitest/autorun'
module Chess

class QueenTester < MiniTest::Unit::TestCase
    puts "QueenPieceTester"
    def test_initialize
      game_board = Board.new
      q = Queen.new(1, 2, :white, game_board)
      assert_equal(1, q.row)
      assert_equal(2, q.column)
      assert_equal(:white, q.color)
      assert_equal(game_board, q.board)
      assert_equal(q, q.board[1,2])
      assert_equal([[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]], q.vector_moves)
    end

    def test_range
      game_board = Board.new
      q = Queen.new(0, 1, :white, game_board)
      assert_equal([[0, 0], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [1, 0],
        [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]], q.range)
    end
  end
end