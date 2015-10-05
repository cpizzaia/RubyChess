class Piece
  attr_reader :color, :board
  def initialize(color, board)
    @color = color
    @board = board
  end

  def move
  end

  def valid_move?(start, finish)
    if start == finish
      puts "naaah"
      return false
    end
  end

end

class Rook < Piece
  def show
    color == :black ? " \u265C " : " \u2656 "
  end
  def valid_move?(start, finish)
    super
    a,b = start
    x,y = finish
    x == a || y == b
  end
end

class Bishop < Piece
  def show
    color == :black ? " \u265D " : " \u2657 "
  end

  def valid_move?(start, finish)
    super
    a,b = start
    x,y = finish
    (x - a).abs == (y - b).abs
  end
end

class Queen < Piece
  def show
    color == :black ? " \u265B " : " \u2655 "
  end

  def valid_move?(start, finish)
    super
    a,b = start
    x,y = finish
    (x - a).abs == (y - b).abs || x == a || y == b
  end
end

class Knight < Piece
  def show
    color == :black ? " \u265E " : " \u2658 "
  end
  def valid_move?(start, finish)
    super
    a,b = start
    x,y = finish
    ((x - a).abs == 1 && (y - b).abs == 2) || ((x - a).abs == 2 && (y - b).abs == 1)
  end

end

class King < Piece
  def show
    color == :black ? " \u265A " : " \u2654 "
  end
  def valid_move?(start, finish)
    super
    a,b = start
    x,y = finish
    (x - a).abs < 2 && (y - b).abs < 2
  end
end

class Pawn < Piece
  def show
    color == :black ? " \u265F " : " \u2659 "
  end

  def valid_move?(start, finish)
    super
    a,b = start
    x,y = finish

    if color == :white && a == 6 && y==b && (x-a).abs == 2
      return true
    elsif color == :black && a == 1 && y==b && (x-a).abs == 2
      return true
    end

    if color == :white && a - x == 1 && (b - y).abs == 1 && !board.grid[x][y].nil? && board.grid[x][y].color != color
      return true
    elsif color == :black && a - x == - 1 && (b - y).abs == 1 && !board.grid[x][y].nil? && board.grid[x][y].color != color
      return true
    end


    #if a == 6

    color == :black ? x-a == +1 && y==b : x-a == -1 && y==b
  end


end
