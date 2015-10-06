class Piece

  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def valid_move?(start, finish)

    # deny move if same color is captured
    x,y = finish
    return false if !@board.position(finish).nil? && @color == @board.position(finish).color

    # deny move if start == finish
    if start == finish
      return false
    end

    # skip collision check if it's a knight
    return true if self.is_a?(Knight)

    #check if there's a collision on the selected path
    collision?(start, finish) ? false : true
  end

  private
  def collision?(start, finish)
    a, b = start
    x, y = finish

    if    x < a  && y == b #up
      (x+1...a).each do |index|
        return true if !@board.grid[index][b].nil?
      end

    elsif x > a  && y == b   #down
      (a+1...x).each do |index|
        return true if !@board.grid[index][b].nil?
      end

    elsif x == a && y < b #left
      (y+1...b).each do |index|
        return true if !@board.grid[a][index].nil?
      end

    elsif x == a && y > b #right
      (b+1...y).each do |index|
        return true if !@board.grid[a][index].nil?
      end

    elsif x < a  && y > b #upright -+
      path_length = (y-b).abs
      (1...path_length).each do |num|
        return true if !@board.grid[a-num][b+num].nil?
      end

    elsif x < a  && y < b#upleft --
      path_length = (y-b).abs
      (1...path_length).each do |num|
        return true if !@board.grid[a-num][b-num].nil?
      end

    elsif x > a  && y > b #downright ++
      path_length = (y-b).abs
      (1...path_length).each do |num|
        return true if !@board.grid[a+num][b+num].nil?
      end

    elsif x > a  && y < b #downleft +-
      path_length = (y-b).abs
      (1...path_length).each do |num|
        return true if !@board.grid[a+num][b-num].nil?
      end

    end
    false

  end

end

class Rook < Piece
  def show
    color == :black ? " \u265C " : " \u2656 "
  end
  def valid_move?(start, finish)
    a,b = start
    x,y = finish
    super if x == a || y == b
  end
end

class Bishop < Piece
  def show
    color == :black ? " \u265D " : " \u2657 "
  end

  def valid_move?(start, finish)
    a,b = start
    x,y = finish
    super if (x - a).abs == (y - b).abs
  end
end

class Queen < Piece
  def show
    color == :black ? " \u265B " : " \u2655 "
  end

  def valid_move?(start, finish)
    a,b = start
    x,y = finish
    super if (x - a).abs == (y - b).abs || x == a || y == b
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
    a,b = start
    x,y = finish
    super if (x - a).abs < 2 && (y - b).abs < 2
  end
end

class Pawn < Piece
  def show
    color == :black ? " \u265F " : " \u2659 "
  end

  def valid_move?(start, finish)
    a,b = start
    x,y = finish


    return false if !@board.grid[x][y].nil? && b==y

    # these allow the pawn to move 2 spaces on their first turn
    if color == :white && a == 6 && y==b && (x-a).abs == 2
      return true
    elsif color == :black && a == 1 && y==b && (x-a).abs == 2
      return true
    end

    # these allow the pawns to attack the opp. color diagonally
    if color == :white && a - x == 1 && (b - y).abs == 1 && !board.grid[x][y].nil? && board.grid[x][y].color != color
      return true
    elsif color == :black && a - x == - 1 && (b - y).abs == 1 && !board.grid[x][y].nil? && board.grid[x][y].color != color
      return true
    end

    #this allows pawn to move forward one step & then check it against 'valid_move?'
    super if color == :black ? x-a == +1 && y==b : x-a == -1 && y==b
  end

end
