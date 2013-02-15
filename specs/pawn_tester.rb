require_relative '../lib/pawn.rb'
require 'minitest/autorun'
module Chess

  class PawnTester < MiniTest::Unit::TestCase
    puts "PawnPieceTester"
    def test_initialize
      game_board = Board.new()
      p1 = Pawn.new(6, 1, :white, game_board)
      assert_equal(6, p1.row)
      assert_equal(1, p1.column)
      assert_equal(:white, p1.player)
      assert_equal(game_board, p1.board)
      assert_equal(p1, p1.board[6, 1])
      assert(p1.first_move)
      assert_equal([[-1, -1], [-1, 0], [-1, 1], [-2, 0]], p1.vector_moves)

      p2 = Pawn.new(1, 2, :black, game_board)
      assert_equal([[1, -1], [1, 0], [1, 1], [2, 0]], p2.vector_moves)
    end

    def test_range
      game_board = Board.new()
      p = Pawn.new(1, 2, :black, game_board)
      assert_equal([[2, 1], [2, 2], [2, 3], [3, 2]], p.range)
    end

    def test_valid_move?
      game_board = Board.new()
      p = Pawn.new(1, 2, :black, game_board)
      assert(p.valid_move?(2, 2))

      assert(!p.valid_move?(4, 2))

      Pawn.new(2, 2, :white, game_board)
      assert(!p.valid_move?(2, 2))
      assert(!p.valid_move?(3, 2))

      assert(!p.valid_move?(2, 3))
      Pawn.new(2, 3, :black, game_board)
      assert(!p.valid_move?(2, 3))
      Pawn.new(2, 3, :white, game_board)
      assert(p.valid_move?(2, 3))

      game_board = Board.new()
      p = Pawn.new(1, 2, :black, game_board)
      p.move(2, 2)
      assert(!p.valid_move?(4, 2))
    end

    def test_move
      game_board = Board.new()
      p = Pawn.new(1, 2, :black, game_board)
      p.move(2, 2)
      assert(!p.first_move)
    end
  end
end