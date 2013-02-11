require_relative '../lib/piece.rb'
require 'minitest/autorun'

module Chess
  class PlacedPieceTester < MiniTest::Unit::TestCase
    puts "PlacedPieceTester"
    def test_initialize
      b = Board.new()
      p = Piece.new(1, 2, :white, b)
      assert_equal(1, p.row)
      assert_equal(2, p.column)
      assert_equal(:white, p.color)
      assert_equal(b, p.board)
      assert_equal(p, p.board[1,2])
    end

    def test_move
      game_board = Board.new()
      b = Bishop.new(3, 4, :white, game_board)
      b.move(1, 2)
      assert_equal(nil, game_board[3,4])
      assert_equal(b, game_board[1,2])
      assert_equal(b.row, 1)
      assert_equal(b.column, 2)

      game_board = Board.new()
      b = Bishop.new(3, 4, :white, game_board)
      assert_raises(IllegalMove) { b.move(2, 2) } # y u assert_raise no work for me!
    end

    def test_range
      game_board = Board.new()
      b = Bishop.new(3, 4, :white, game_board)
      assert_equal([[2, 3], [1, 2], [0, 1], [2, 5], [1, 6], [0, 7], [4, 3], [5, 2], [6, 1], [7, 0], [4, 5], [5, 6], [6, 7]], b.range)
    end

    def test_valid_destination?
      game_board = Board.new
      b1 = Bishop.new(3, 4, :white, game_board)
      assert(!b1.valid_move?(0, 0))

      b2 = Bishop.new(5, 6, :white, game_board)
      assert(!b1.valid_move?(5, 6))

      b3 = Bishop.new(5, 6, :black, game_board)
      assert(b1.valid_move?(5, 6))

      b4 = Bishop.new(4, 5, :black, game_board)
      assert(!b1.valid_move?(5, 6))
    end

    def test_leap?
      game_board = Board.new
      b1 = Bishop.new(3, 4, :white, game_board)
      assert_equal(false, b1.leap?(5, 6))

      b2 = Bishop.new(5, 6, :black, game_board)
      b3 = Bishop.new(4, 5, :black, game_board)
      assert(b1.leap?(5, 6))
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
      assert(!b1.move_causes_self_check?(3, 3))

      assert(!b1.move_causes_self_check?(4, 5))

      k = King.new(2, 3, :white, game_board)
      b2 = Bishop.new(5, 6, :black, game_board)
      assert(b1.move_causes_self_check?(2, 5))
    end

  end
end