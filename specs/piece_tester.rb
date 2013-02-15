require_relative '../lib/piece.rb'
require 'minitest/autorun'

module Chess
  class PlacedPieceTester < MiniTest::Unit::TestCase
    puts "PlacedPieceTester"
    def test_initialize
      game_board = Board.new
      p = Piece.new(1, 2, :white, game_board)
      assert_equal(1, p.row)
      assert_equal(2, p.column)
      assert_equal(:white, p.player)
      assert_equal(game_board, p.board)
      assert_equal(p, p.board[1,2])
    end

    def test_move
      game_board = Board.new
      b = Bishop.new(3, 4, :white, game_board)
      b.move(1, 2)
      assert_equal(nil, game_board[3,4])
      assert_equal(b, game_board[1,2])
      assert_equal(b.row, 1)
      assert_equal(b.column, 2)

      game_board = Board.new
      k = King.new(0, 0, :white, game_board)
      game_board = Bishop.new(3, 4, :black, game_board)
      assert_raises(IllegalMove) { game_board.move(2, 2) } # y u assert_raise no work for me!
      assert_raises(IllegalMove) { k.move(0, 1) }

      game_board = Board.new.reset
      r = game_board[0, 0]
      assert_raises(IllegalMove) { r.move(0, 7) }

      game_board = Board.new
      k = King.new(0, 0, :white, game_board)
      b = Bishop.new(4, 4, :black, game_board)
      assert_raises(IllegalMove) { k.move(1, 1) }
   end

    def test_range
      game_board = Board.new()
      game_board = Bishop.new(3, 4, :white, game_board)
      assert_equal([[2, 3], [1, 2], [0, 1], [2, 5], [1, 6], [0, 7], [4, 3], [5, 2], [6, 1], [7, 0], [4, 5], [5, 6], [6, 7]], game_board.range)
    end

    def test_valid_move?
      game_board = Board.new
      b1 = Bishop.new(3, 4, :white, game_board)
      assert(!b1.valid_move?(0, 0))

      b2 = Bishop.new(5, 6, :white, game_board)
      assert(!b1.valid_move?(5, 6))

      b3 = Bishop.new(5, 6, :black, game_board)
      assert(b1.valid_move?(5, 6))

      b4 = Bishop.new(4, 5, :black, game_board)
      assert(!b1.valid_move?(5, 6))

      game_board = Board.new
      k = King.new(0, 0, :white, game_board)
      game_board = Bishop.new(4, 5, :black, game_board)
      assert(!k.valid_move?(0, 1))

      game_board = Board.new
      k = King.new(4, 4, :white, game_board)
      game_board = Bishop.new(2, 2, :black, game_board)
      assert(!game_board.valid_move?(6, 6))

      game_board = Board.new.reset
      r = game_board[0, 0]
      assert(!r.valid_move?(5, 0))
      assert(!r.valid_move?(0, 1))
    end


    def test_leap?
      game_board = Board.new
      b1 = Bishop.new(3, 4, :white, game_board)
      assert(!b1.leap?(5, 6))

      b2 = Bishop.new(5, 6, :black, game_board)
      b3 = Bishop.new(4, 5, :black, game_board)
      assert(b1.leap?(5, 6))

      game_board = Board.new
      r1 = Rook.new(3, 0, :white, game_board)
      k = King.new(3, 3, :white, game_board)
      r2 = Rook.new(3, 6, :black, game_board)
      assert(r1.leap?(3, 6))
    end

    def test_under_attack?
      game_board = Board.new
      b1 = Bishop.new(3, 4, :white, game_board)
      assert(!b1.under_attack?)

      b2 = Bishop.new(6, 7, :white, game_board)
      assert(!b1.under_attack?)

      b3 = Bishop.new(6, 7, :black, game_board)
      assert(b1.under_attack?)
    end

    def test_move_causes_self_check?
      game_board = Board.new
      b1 = Bishop.new(3, 4, :white, game_board)
      assert_raises(IllegalMove) { b1.move_causes_self_check?(3, 3) } # TO DO: ? is it good raising ex?


      game_board = Board.new
      k = King.new(0, 0, :white, game_board)
      b1 = Bishop.new(2, 2, :white, game_board)
      b2 = Bishop.new(4, 4, :black, game_board)
      assert(b1.move_causes_self_check?(0, 4))
      assert(!b1.move_causes_self_check?(4, 4))
      b3 = Bishop.new(4, 5, :black, game_board)
      assert(k.move_causes_self_check?(0, 1))
    end

  end
end