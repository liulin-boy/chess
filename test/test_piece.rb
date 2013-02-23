require 'piece'
require 'minitest/autorun'

module Chess
  class PieceTester < MiniTest::Unit::TestCase
    def test_same_as
      board1 = Board.new
      board2 = Board.new
      b1 = Bishop.new(3, 4, :white, board1)
      assert !b1.same_as?(Object.new)
      assert b1.same_as?(b1)

      b2 = Bishop.new(3, 4, :white, board1)
      assert b1.same_as?(b2)

      b3 = Bishop.new(4, 5, :white, board1)
      assert !b1.same_as?(b3)

      b4 = Bishop.new(3, 5, :white, board1)
      assert !b1.same_as?(b4)

      b5 = Bishop.new(3, 4, :black, board1)
      assert !b1.same_as?(b5)

      r1 = Rook.new(3, 4, :white, board1)
      assert !b1.same_as?(r1)

      r2 = Rook.new(4, 4, :white, board2)
      r2.move(3, 4)
      assert !r1.same_as?(r2)
    end

    def test_initialize
      board = Board.new
      p = Piece.new(1, 2, :white, board)
      assert_equal 1, p.row
      assert_equal 2, p.column
      assert_equal :white, p.player
      assert_equal board, p.board
      assert p.first_move?
      assert_equal p, p.board[1,2]

      p = Piece.new(1, 2, :white, board, false)
      assert !p.first_move?
    end

    def test_move
      board = Board.new
      b = Bishop.new(3, 4, :white, board)
      b.move(1, 2)
      assert_equal nil, board[3,4]
      assert_equal b, board[1,2]
      assert_equal 1, b.row
      assert_equal 2, b.column

      board = Board.new
      k = King.new(0, 0, :white, board)
      board = Bishop.new(3, 4, :black, board)
      assert_raises(IllegalMove) { board.move(2, 2) } # y u assert_raise no work for me!
      assert_raises(IllegalMove) { k.move(0, 1) }

      board = Board.new.reset
      r = board[0, 0]
      assert_raises(IllegalMove) { r.move(0, 7) }

      board = Board.new
      k = King.new(0, 0, :white, board)
      b = Bishop.new(4, 4, :black, board)
      assert_raises(IllegalMove) { k.move(1, 1) }
   end

    def test_range
      board = Board.new()
      board = Bishop.new(3, 4, :white, board)
      expected_range = [[2, 3], [1, 2], [0, 1], [2, 5], [1, 6], [0, 7], [4, 3], [5, 2], [6, 1], [7, 0], [4, 5], [5, 6], [6, 7]]
      assert_equal expected_range, board.range
    end

    def test_valid_move?
      board = Board.new
      b1 = Bishop.new(3, 4, :white, board)
      assert !b1.valid_move?(0, 0)

      b2 = Bishop.new(5, 6, :white, board)
      assert !b1.valid_move?(5, 6)

      b3 = Bishop.new(5, 6, :black, board)
      assert b1.valid_move?(5, 6)

      b4 = Bishop.new(4, 5, :black, board)
      assert !b1.valid_move?(5, 6)

      board = Board.new
      k = King.new(0, 0, :white, board)
      board = Bishop.new(4, 5, :black, board)
      assert !k.valid_move?(0, 1)

      board = Board.new
      k = King.new(4, 4, :white, board)
      board = Bishop.new(2, 2, :black, board)
      assert !board.valid_move?(6, 6)

      board = Board.new.reset
      r = board[0, 0]
      assert !r.valid_move?(5, 0)
      assert !r.valid_move?(0, 1)
    end


    def test_leap?
      board = Board.new
      b1 = Bishop.new(3, 4, :white, board)
      assert !b1.leap?(5, 6)

      b2 = Bishop.new(5, 6, :black, board)
      b3 = Bishop.new(4, 5, :black, board)
      assert b1.leap?(5, 6)

      board = Board.new
      r1 = Rook.new(3, 0, :white, board)
      k = King.new(3, 3, :white, board)
      r2 = Rook.new(3, 6, :black, board)
      assert r1.leap?(3, 6)
    end

    def test_under_attack?
      board = Board.new
      b1 = Bishop.new(3, 4, :white, board)
      assert !b1.under_attack?

      b2 = Bishop.new(6, 7, :white, board)
      assert !b1.under_attack?

      b3 = Bishop.new(6, 7, :black, board)
      assert b1.under_attack?
    end

    def test_move_causes_self_check?
      board = Board.new
      b1 = Bishop.new(3, 4, :white, board)
      assert_raises(IllegalMove) { b1.move_causes_self_check?(3, 3) }

      board = Board.new
      k = King.new(0, 0, :white, board)
      b1 = Bishop.new(2, 2, :white, board)
      b2 = Bishop.new(4, 4, :black, board)
      assert b1.move_causes_self_check?(0, 4)
      assert !b1.move_causes_self_check?(4, 4)
      b3 = Bishop.new(4, 5, :black, board)
      assert k.move_causes_self_check?(0, 1)

      board = Board.new
      k = King.new(7, 0, :white, board)
      r = Rook.new(0, 4, :white, board)
      King.new(1, 5, :black, board)
      Queen.new(6, 0, :black, board)
      Knight.new(4, 1, :black, board)
      assert r.move_causes_self_check?(0, 5)
    end
  end
end