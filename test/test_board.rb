$:.unshift('chess/lib') # full path: D:/Program Files/Ruby/Ruby193/bin/chess/lib
require 'board'
require 'game'
require 'minitest/autorun'
require_relative 'accessors'
require 'mysql2'

module Chess
  class BoardTester < MiniTest::Unit::TestCase
    def test_reader
      game_board = Board.new
      assert_nil game_board[1,2]
      k = King.new(1, 2, :white, game_board)
      assert_equal k, game_board[1, 2]
    end

    def test_writer
      b = Board.new
      b[1,2] = :test
      assert_equal(:test, b[1,2])
    end

    def test_same_as
      board1 = Board.new
      assert board1.same_as?(board1)

      board2 = Board.new
      assert board1.same_as?(board2)

      assert board1.reset.same_as?(board2.reset)

      board1 = Board.new.reset
      board2 = Board.new.reset
      assert board1.same_as?(board1)
      board1.make_move('d2', 'd4', :white)
      assert !board1.same_as?(board2)

      board1 = Board.new.reset
      board2 = Board.new.reset
      Pawn.new(1, 2, :white, board1)
      assert !board1.same_as?(board2)
    end

    def test_find_king
      game_board = Board.new
      assert_nil  game_board.find_king(:white)
      k = King.new 1, 2, :black, game_board
      k2 = King.new 6, 7, :white, game_board
      assert_equal k2, game_board.find_king(:white)
      assert_equal k, game_board.find_king(:black)

    end

    def test_deep_copy
      game_board = Board.new.reset
      copy_board = game_board.deep_copy

      assert copy_board.same_as?(game_board)

      assert copy_board.make_move('a2', 'a4', :white)
      assert !copy_board.same_as?(game_board)

      game_board = Board.new.reset
      copy_board = game_board.deep_copy
      assert game_board.make_move('e7', 'e5', :black)
      assert !copy_board.same_as?(game_board)
    end

    def xtest_move
      game_board = Board.new.reset
      assert game_board.make_move('d2', 'd4', :white)
      assert game_board.make_move('e7', 'e5', :black)
      assert game_board.make_move('a2', 'a3', :white)
      assert game_board.make_move('e5', 'd4', :black)
      assert game_board.make_move('d1', 'd4', :white)
      assert game_board.make_move('g8', 'h6', :black)
      assert game_board.make_move('d4', 'e5', :white)
      assert !game_board.make_move('a7', 'a6', :black)
      assert !game_board.make_move('h6', 'g4', :black)
      assert game_board.make_move('f8', 'e7', :black)

      game_board.show
    end

    def xtest_game_run
      game_board = Board.new.reset
      Game.new(game_board).play
    end

    def test_load_from_string
      game_board1 = Board.new
      k = King.new(7, 0, :white, game_board1)
      n = Knight.new(6, 1, :black, game_board1)
      p = Pawn.new(4, 4, :black, game_board1)
      game_board2 = Board.load_from_string('wKa1 bNb2 bpe4')

      assert game_board1.same_as?(game_board2)
    end

    def test_to_string
      game_board = Board.new
      assert_equal '', game_board.to_string
      k = King.new(0, 4, :black, game_board)
      b = Bishop.new(3, 4, :black, game_board)
      r = Rook.new(7, 2, :white, game_board)
      assert_equal 'bKe8 bBe5 wRc1', game_board.to_string
    end


    def xtest_save_to_database
      game_board = Board.new
      k = King.new(0, 4, :black, game_board)
      b = Bishop.new(3, 4, :black, game_board)
      r = Rook.new(7, 2, :white, game_board)

      db = Mysql2::Client.new(:host => "localhost", :username => "root", :port => 3306, :database => "ruby")
      game_board.save_to_database(db, "test_board")
      p results = db.query("SELECT * FROM test_board")
      results.map {|item| p item}
      db.query("SELECT * FROM test_board")

      db.query("DROP TABLE IF EXISTS test_board")
    end
  end
end