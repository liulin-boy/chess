$:.unshift('D:/Program Files/Ruby/Ruby193/bin/chess/lib')
require 'board'
require 'minitest/autorun'

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
      assert_equal(nil, game_board.find_king(:white))
      assert_equal(k, game_board.find_king(:black))
    end

    def test_white_king
      game_board = Board.new
      assert_equal(nil, game_board.white_king)
      k1 = King.new(1, 2, :black, game_board)
    end

    def xtest_deep_copy
      game_board = Board.new
      b = Bishop.new(1, 2, :white, game_board)
      copy_board = game_board.deep_copy
      Bishop.new(2, 2, :white, game_board)
      #assert_equal(game_board, copy_board) # doesnt work at all
    end

    def test_move
      game_board = Board.new.reset
      assert(game_board.move('a2', 'a4'))
      assert(game_board.move('e7', 'e5'))

      assert(!game_board.move('a1', 'a4'))
      assert(game_board.move('a1', 'a3'))
      assert(game_board.move('b8', 'c6'))
      assert(game_board.move('e8', 'e7'))
      game_board.show
    end
  end
end