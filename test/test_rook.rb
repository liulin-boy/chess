require 'rook'
require 'minitest/autorun'

module Chess
  class RookTester < MiniTest::Unit::TestCase
    def test_initialize
      board = Board.new
      r = Rook.new(1, 2, :white, board)
      assert_equal 1, r.row
      assert_equal 2, r.column
      assert_equal :white, r.player
      assert_equal board, r.board
      assert_equal r, r.board[1,2]
      assert_equal [[-1, 0], [1, 0], [0, -1], [0, 1]], r.vector_moves
    end

    def test_castle
      board = Board.new
      r = Rook.new(0, 0, :black, board)
      assert_raises(IllegalMove) {r.castle}

      k = King.new(0, 4, :black, board)
      assert r.castle
      assert_equal k, board[0, 2]
      assert_equal r, board[0, 3]
      assert_nil board[0, 0]
      assert_nil board[0, 4]
      assert !r.first_move?
      assert !k.first_move?

      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 7, :white, board)
      assert r.castle
      assert_equal k, board[7, 6]
      assert_equal r, board[7, 5]
      assert_nil board[7, 4]
      assert_nil board[7, 7]
      assert !r.first_move?
      assert !k.first_move?

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      r.move(1, 0)
      r.move(0, 0)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      k.move(1, 4)
      k.move(0, 4)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 7, :white, board)
      b = Bishop.new(5, 2, :black, board)
      assert_raises(IllegalMove) { r.castle }
      assert r.first_move?
      assert k.first_move?

      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 7, :white, board)
      b = Bishop.new(5, 3, :black, board)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 7, :white, board)
      b = Bishop.new(5, 4, :black, board)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      b = Bishop.new(2, 4, :white, board)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      b = Bishop.new(2, 5, :white, board)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      b = Bishop.new(2, 6, :white, board)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      q = Queen.new(0, 3, :black, board)
      assert_raises(IllegalMove) { r.castle }

      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 7, :white, board)
      b = Bishop.new(7, 5, :white, board)
      assert_raises(IllegalMove) { r.castle }
    end
  end
end