$:.unshift('chess/lib')
require 'board'
require 'game'
require 'minitest/autorun'
require_relative 'utilities'
require 'mysql2'

module Chess
  class BoardTester < MiniTest::Unit::TestCase
    def test_reader
      board = Board.new
      assert_nil board[1,2]
      k = King.new(1, 2, :white, board)
      assert_equal k, board[1, 2]
    end

    def test_writer
      b = Board.new
      b[1,2] = :test
      assert_equal :test, b[1,2]
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
      board = Board.new
      assert_nil  board.find_king(:white)
      k = King.new 1, 2, :black, board
      k2 = King.new 6, 7, :white, board
      assert_equal k2, board.find_king(:white)
      assert_equal k, board.find_king(:black)
    end

    def test_move
      board = Board.new.reset
      assert board.make_move('d2', 'd4', :white)
      assert board.make_move('e7', 'e5', :black)
      assert board.make_move('a2', 'a3', :white)
      assert board.make_move('e5', 'd4', :black)
      assert board.make_move('d1', 'd4', :white)
      assert board.make_move('g8', 'h6', :black)
      assert board.make_move('d4', 'e5', :white)
      assert_raises(IllegalMove) { board.make_move('a7', 'a6', :black) }
      assert_raises(IllegalMove) { board.make_move('h6', 'g4', :black) }
      assert_raises(IllegalMove) { board.make_move('f8', 'e7', :white) }
      assert board.make_move('f8', 'e7', :black)
    end

    def test_kingside_castle
      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 7, :white, board)
      assert board.kingside_castle(:white)

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 7, :black, board)
      b = Bishop.new(2, 4, :white, board)
      assert_raises(IllegalMove) { board.kingside_castle(:black) }
    end

    def test_queenside_castle
      board = Board.new
      k = King.new(7, 4, :white, board)
      r = Rook.new(7, 0, :white, board)
      assert board.queenside_castle(:white)

      board = Board.new
      k = King.new(0, 4, :black, board)
      r = Rook.new(0, 0, :black, board)
      b = Bishop.new(2, 4, :white, board)
      assert_raises(IllegalMove) { board.queenside_castle(:black) }
    end

    def xtest_game_run
      board = Board.new.reset
      Game.new(board).play
    end

    def test_deep_copy
      board = Board.new.reset
      copy_board = board.deep_copy

      assert copy_board.same_as?(board)

      assert copy_board.make_move('a2', 'a4', :white)
      assert !copy_board.same_as?(board)

      board = Board.new.reset
      copy_board = board.deep_copy
      assert board.make_move('e7', 'e5', :black)
      assert !copy_board.same_as?(board)
    end

    def test_to_string
      board = Board.new
      assert_equal "", board.to_string
      k = King.new(0, 4, :black, board)
      b = Bishop.new(3, 4, :black, board, false)
      r = Rook.new(7, 2, :white, board)
      expected_string = "black King e8; black Bishop e5 moved; white Rook c1;"
      assert_equal expected_string, board.to_string
    end

    def test_load_from_string
      assert_raises(RuntimeError) { Board.load_from_string('illegal string') }
      assert_raises(RuntimeError) { Board.load_from_string('white Foo a2; black Bishop b2 moved') }
      assert_raises(RuntimeError) { Board.load_from_string('white King a2; blue Bishop b2 moved') }
      assert_raises(RuntimeError) { Board.load_from_string('white King z2; black Bishop b2 moved') }
      assert_raises(RuntimeError) { Board.load_from_string('white King a9; black Bishop b2 moved') }
      assert_raises(RuntimeError) { Board.load_from_string('white King z2; black Bishop b2 bar') }
      assert_raises(RuntimeError) { Board.load_from_string('white King z2. black Bishop b2 moved') }

      board1 = Board.new
      k = King.new(7, 0, :white, board1)
      n = Knight.new(6, 1, :black, board1, false)
      p = Pawn.new(4, 4, :black, board1, false)
      board2 = Board.load_from_string('black Knight b2 moved; white King a1; black Pawn e4 moved')
      assert board2.same_as?(board1)

      assert board1.same_as?(Board.load_from_string(board1.to_string))
    end

    def test_save_to_database
      board1 = Board.new
      k = King.new(0, 4, :black, board1)
      b = Bishop.new(3, 4, :black, board1)
      r = Rook.new(7, 2, :white, board1)

      mysql2_client = Mysql2::Client.new(:host => "localhost", :username => "root", :port => 3306, :database => "ruby")
      mysql2_client.query("DROP TABLE IF EXISTS test_board")
      board1.save_to_database(mysql2_client, "test_board")
      results = mysql2_client.query("SELECT * FROM test_board")
      board2 = Board.new
      results.each do |item|
        piece_type = eval(item["piece_type"])
        row        = Board::ROW[item["rank"].to_s]
        column     = Board::COLUMN[item["file"]]
        player     = item["player"].to_sym
        first_move = item["first_move"] == "1"
        piece_type.new(row, column, player, board2, first_move)
      end
      assert board2.same_as?(board1)
    end

    def test_load_from_database
      mysql2_client = Mysql2::Client.new(:host => "localhost", :username => "root", :port => 3306, :database => "ruby")
      assert_raises(RuntimeError) { Board.load_from_database(mysql2_client, "nonexistent_table") }

      board1 = Board.new
      k = King.new(0, 4, :black, board1)
      b = Bishop.new(3, 4, :black, board1)
      r = Rook.new(7, 2, :white, board1)
      mysql2_client.query("DROP TABLE IF EXISTS test_board")
      board1.save_to_database(mysql2_client, "test_board")
      assert Board.load_from_database(mysql2_client, "test_board")

      mysql2_client.query("UPDATE test_board SET test_board.piece_type = 'Foo' WHERE test_board.piece_type = 'King';")
      assert_raises(RuntimeError) { Board.load_from_database(mysql2_client, "test_board") }

      mysql2_client.query("DROP TABLE IF EXISTS test_board")
      board1.save_to_database(mysql2_client, "test_board")
      mysql2_client.query("UPDATE test_board SET test_board.player = 'blue' WHERE test_board.player = 'white';")
      assert_raises(RuntimeError) { Board.load_from_database(mysql2_client, "test_board") }

      mysql2_client.query("DROP TABLE IF EXISTS test_board")
      board1.save_to_database(mysql2_client, "test_board")
      mysql2_client.query("UPDATE test_board SET test_board.file = 'z' WHERE test_board.piece_type = 'King';")
      assert_raises(RuntimeError) { Board.load_from_database(mysql2_client, "test_board") }

      mysql2_client.query("DROP TABLE IF EXISTS test_board")
      board1.save_to_database(mysql2_client, "test_board")
      mysql2_client.query("UPDATE test_board SET test_board.rank = 10 WHERE test_board.piece_type = 'King';")
      assert_raises(RuntimeError) { Board.load_from_database(mysql2_client, "test_board") }

      mysql2_client.query("DROP TABLE IF EXISTS test_board")
      board1.save_to_database(mysql2_client, "test_board")
      mysql2_client.query("UPDATE test_board SET test_board.first_move = 2 WHERE test_board.piece_type = 'King';")
      assert_raises(RuntimeError) { Board.load_from_database(mysql2_client, "test_board") }
      mysql2_client.query("DROP TABLE IF EXISTS test_board")
    end
  end
end
