require 'king'
require 'bishop'
require 'minitest/autorun'
module Chess
  class KingTester < MiniTest::Unit::TestCase
    puts "KingPieceTester"
    def test_initialize
      game_board = Board.new()
      k = King.new(1, 2, :white, game_board)
      assert_equal(1, k.row)
      assert_equal(2, k.column)
      assert_equal(:white, k.color)
      assert_equal(game_board, k.board)
      assert_equal(k, k.board[1,2])
      assert(k.first_move)
      assert_equal([[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]], k.vector_moves)
    end

    def test_in_check?
      game_board = Board.new()
      k = King.new(1, 2, :white, game_board)
      b = Bishop.new(5, 6, :black, game_board)
      assert(k.in_check?)
      b = Bishop.new(3, 4, :white, game_board)
      assert_equal(false, k.in_check?)
    end

    def test_range
      game_board = Board.new()
      k = King.new(0, 1, :white, game_board)
      assert_equal([[0, 2], [1, 2], [1, 1], [1, 0], [0, 0]], k.range)
    end

    def test_move
      game_board = Board.new()
      k = King.new(0, 1, :white, game_board)
      assert_raises(IllegalMove) { k.move(1, 3) }

      k.move(1, 2)
      assert_equal(nil, game_board[0, 1])
      assert_equal(k, game_board[1, 2])
      assert_equal(1, k.row)
      assert_equal(2, k.column)
      assert(!k.first_move)
    end
  end
end