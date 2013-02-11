require 'queen'
require 'minitest/autorun'
module Chess

class QueenTester < MiniTest::Unit::TestCase
    puts "QueenPieceTester"
    def test_initialize
      game_board = Board.new()
      q = Queen.new(1, 2, :white, game_board)
      assert_equal(1, q.row)
      assert_equal(2, q.column)
      assert_equal(:white, q.color)
      assert_equal(game_board, q.board)
      assert_equal(q, q.board[1,2])
      assert_equal([[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]], q.vector_moves)

#      p q.range
    end
  end
end