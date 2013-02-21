require 'rook'
require 'minitest/autorun'
#require_relative 'utilities'

module Chess
  class RookTester < MiniTest::Unit::TestCase
    def test_initialize
      game_board = Board.new()
      r = Rook.new(1, 2, :white, game_board)
      assert_equal 1, r.row
      assert_equal 2, r.column
      assert_equal :white, r.player
      assert_equal game_board, r.board
      assert_equal r, r.board[1,2]
      assert_equal [[-1, 0], [1, 0], [0, -1], [0, 1]], r.vector_moves
    end

    def test_castle
      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      r.castle
      assert_equal k, game_board[0, 2]
      assert_equal r, game_board[0, 3]
      assert_nil game_board[0, 0]
      assert_nil game_board[0, 4]
      assert !r.first_move?
      assert !k.first_move?

      game_board = Board.new()
      k = King.new(7, 4, :white, game_board)
      r = Rook.new(7, 7, :white, game_board)
      r.castle
      assert_equal k, game_board[7, 6]
      assert_equal r, game_board[7, 5]
      assert_nil game_board[7, 4]
      assert_nil game_board[7, 7]
      assert !r.first_move?
      assert !k.first_move?

      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      r.move(1, 0)
      r.move(0, 0)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      k.move(1, 4)
      k.move(0, 4)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(7, 4, :white, game_board)
      r = Rook.new(7, 7, :white, game_board)
      b = Bishop.new(5, 2, :black, game_board)
      assert_raises(IllegalMove) { r.castle }
      assert r.first_move?
      assert k.first_move?



      game_board = Board.new()
      k = King.new(7, 4, :white, game_board)
      r = Rook.new(7, 7, :white, game_board)
      b = Bishop.new(5, 3, :black, game_board)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(7, 4, :white, game_board)
      r = Rook.new(7, 7, :white, game_board)
      b = Bishop.new(5, 4, :black, game_board)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      b = Bishop.new(2, 4, :white, game_board)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      b = Bishop.new(2, 5, :white, game_board)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      b = Bishop.new(2, 6, :white, game_board)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(0, 4, :black, game_board)
      r = Rook.new(0, 0, :black, game_board)
      q = Queen.new(0, 3, :black, game_board)
      assert_raises(IllegalMove) { r.castle }

      game_board = Board.new()
      k = King.new(7, 4, :white, game_board)
      r = Rook.new(7, 7, :white, game_board)
      b = Bishop.new(7, 5, :white, game_board)
      assert_raises(IllegalMove) { r.castle }
    end
  end
end