require 'mysql2'
client = Mysql2::Client.new(:host => "localhost", :username => "root", :port => 3306, :database => "ruby")
#results = client.query("SELECT * FROM example")
#p results.methods.sort
#results.map {|item| p item}

#p results = client.query("SELECT * FROM board")
#client.query("INSERT INTO board (id, piece_type, player, file, rank, first_move) VALUES(3, 'King', 'black', 'c', 2, false)")
#p results.to_a.empty?
#results.map {|item| p item}

#client.query("SELECT * FROM board")
