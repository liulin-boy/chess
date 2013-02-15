$:.unshift('D:/Program Files/Ruby/Ruby193/bin/chess/lib')
require 'board'
require 'minitest/autorun'
require 'game'

module Chess
  class BoardTester < MiniTest::Unit::TestCase
    puts "BoardTester"
    def test_reader
      assert_equal(nil, Board.new[1,2])
    end

    def test_writer
      b = Board.new
      b[1,2]=:test
      assert_equal(:test, b[1,2])
    end

    def test_find_king
      game_board = Board.new
      assert_equal(nil, game_board.find_king(:white))
      k = King.new(1, 2, :black, game_board)
      k2 = King.new(6, 7, :white, game_board)
      assert_equal(k2, game_board.find_king(:white))
      assert_equal(k, game_board.find_king(:black))

    end

    def xtest_deep_copy
      game_board = Board.new.reset
      copy_board = game_board.deep_copy

      assert(copy_board.make_move('a2', 'a4', :white))
      assert(game_board.make_move('e7', 'e5', :black))

      game_board.show

      copy_board.show
    end

    def xtest_move
      game_board = Board.new.reset
      assert(game_board.make_move('d2', 'd4', :white))
      assert(game_board.make_move('e7', 'e5', :black))
      assert(game_board.make_move('a2', 'a3', :white))
      assert(game_board.make_move('e5', 'd4', :black))
      assert(game_board.make_move('d1', 'd4', :white))
      assert(game_board.make_move('g8', 'h6', :black))
      assert(game_board.make_move('d4', 'e5', :white))
      assert(!game_board.make_move('a7', 'a6', :black))
      assert(!game_board.make_move('h6', 'g4', :black))
      assert(game_board.make_move('f8', 'e7', :black))

      game_board.show
    end

    def xtest_game_run
      game_board = Board.new.reset
      Game.new(game_board).play
    end

    def xtest_load_from_string
      game_board = Board.load_from_string('wKa1 bNb2 bpe4')
      game_board.show
    end
  end
end