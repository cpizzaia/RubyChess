
require_relative "piece"
require 'byebug'
require "colorize"

class Board

  attr_reader :result, :grid

  def initialize(size = 8)
    @grid = Array.new(size) {Array.new(size) {nil}}
    #populate_board
  end

  def populate_board
    for i in 0..@grid.length-1
      for j in 0..@grid.length-1
        if i == 0 && j == 0
          @grid[i][j] = Piece.new
        end
      end
    end
  end

end
