require 'game'
require 'minitest/autorun'
require_relative 'utilities'
module Chess
  class GameTester < MiniTest::Unit::TestCase
    def test_initialize
      game = Game.new
      assert game.board.same_as?(Board.new.reset)
      assert_equal :white, game.current_player

      board = Board.new
      King.new(1, 2, :white, board)
      game = Game.new(board, :black)
      assert game.board.same_as?(board)
      assert_equal :black, game.current_player
    end
  end
end