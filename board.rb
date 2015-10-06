
require_relative "piece"

require 'byebug'
require "colorize"
require "byebug"


class Board

  attr_reader :result, :grid

  def initialize(size = 8)
    @grid = Array.new(size) {Array.new(size) {nil}}
    populate_board
  end

  def populate_board
    for i in 0..@grid.length-1
      for j in 0..@grid.length-1
          @grid[i][j] = proper_piece(i,j)
      end
    end
  end

  def proper_piece(i, j)
    case i
    when 1
      return Pawn.new(:black, self)
    when 6
      return Pawn.new(:white, self)
    end


    case [i,j]
    when [0,7]
      Rook.new(:black, self)
    when [0,0]
      Rook.new(:black, self)
    when [7,7]
      Rook.new(:white, self)
    when [7,0]
      Rook.new(:white, self)
    when [0,2]
      Bishop.new(:black, self)
    when [0,5]
      Bishop.new(:black, self)
    when [7,2]
      Bishop.new(:white, self)
    when [7,5]
      Bishop.new(:white, self)
    when [0,3]
      Queen.new(:black, self)
    when [7,3]
      Queen.new(:white, self)
    when [0,1]
      Knight.new(:black, self)
    when [0,6]
      Knight.new(:black, self)
    when [7,1]
      Knight.new(:white, self)
    when [7,6]
      Knight.new(:white, self)
    when [0,4]
      King.new(:black, self)
    when [7,4]
      King.new(:white, self)
    else
      nil
    end
  end

  def position(arr)
    x, y = arr
    @grid[x][y]
  end

  def get_piece(arr)
    x, y = arr
    @grid[x][y]
  end

end
