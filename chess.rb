$:.unshift('chess/lib')
require 'game'

module Chess
  Game.new.play
end