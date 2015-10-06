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

  def piece_direction(start, finish)
    a, b = start
    x, y = finish

    if    x < a  && y == b #up
      :up
    elsif x > a  && y == b   #down
      :down
    elsif x == a && y < b #left
      :left
    elsif x == a && y > b #right
      :right
    elsif x < a  && y > b #upright -+
      :upright
    elsif x < a  && y < b#upleft --
      :upleft
    elsif x > a  && y > b #downright ++
      :downright
    elsif x > a  && y < b #downleft +-
      :downleft
    end
  end

  def occupied_square? (row, col)
    !@board.grid[row][col].nil?
  end

  def collision?(start, finish)
    a, b = start
    x, y = finish
    path_length = (y-b).abs

    case piece_direction(start, finish)
    when :up
      (x+1...a).each { |i| return true if occupied_square?(i, b) }
    when :down
      (a+1...x).each { |i| return true if occupied_square?(i, b) }
    when :left
      (y+1...b).each { |i| return true if occupied_square?(a, i) }
    when :right
      (b+1...y).each { |i| return true if occupied_square?(a, i) }
    when :upright
      (1...path_length).each { |i| return true if occupied_square?(a-i, b+i) }
    when :downright
      (1...path_length).each { |i| return true if occupied_square?(a+i, b+i) }
    when :downleft
      (1...path_length).each { |i| return true if occupied_square?(a+i, b-i) }
    when :upleft
      (1...path_length).each { |i| return true if occupied_square?(a-i, b-i) }
    else
      raise "error"
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
  def find_king
    @board.grid.each.with_index do |row, i|
      row.each.with_index do |tile, j|
        return [i,j] if tile == self
      end
    end
    puts "cannot find king"
    sleep(5)
  end

  def threat?(piece, dir)
    if dir == :up || dir == :down || dir == :left || dir == :right
      piece.is_a?(Queen) || piece.is_a?(Rook)
    elsif dir == :upleft || dir == :downright || dir == :downleft || dir == :upright
      piece.is_a?(Queen) || piece.is_a?(Bishop)
    end
  end

  def danger?(x, y, direction)
    piece = @board.get_piece([x,y])
    if occupied_square?(x, y) && piece.color == color
      false
    else
      threat?(piece, direction)
    end
  end

  def piece_same_color?(x, y)
    piece = @board.get_piece([x, y])
    if !piece.nil?
      @board.get_piece([x, y]).color == self.color
    else
      false
    end
  end

  def in_check?
    a, b = find_king

    if color == :black
      return true if @board.get_piece([a+1,b+1]).is_a?(Pawn) && @board.get_piece([a+1,b+1]).color == :white
      return true if @board.get_piece([a+1,b-1]).is_a?(Pawn) && @board.get_piece([a+1,b-1]).color == :white
    elsif color == :white
      return true if @board.get_piece([a-1,b+1]).is_a?(Pawn) && @board.get_piece([a-1,b+1]).color == :black
      return true if @board.get_piece([a-1,b-1]).is_a?(Pawn) && @board.get_piece([a-1,b-1]).color == :black
    end

    #when :up
    (a-1).downto(0) { |i| danger?(i, b, :up) ? (return true) : (break if piece_same_color?(i, b)) }
    #when :down
    (a+1).upto(7) { |i| danger?(i, b, :down) ? (return true) : (break if piece_same_color?(i, b)) }
    #when :left
    (b-1).downto(0) { |i| danger?(a, i, :left) ? (return true) : (break if piece_same_color?(a, i)) }
    #when :right
    (b+1).upto(7) { |i| danger?(a, i, :right) ? (return true) : (break if piece_same_color?(a, i)) }
    #when :upright
    i=1
    while a - i >=0 && b + i <= 7
      danger?(a-i, b+i, :upright) ? (return true) : (break if piece_same_color?(a-i, b+i))
      i += 1
    end
    #when :downright
    i=1
    while a + i <=7 && b + i <= 7
      danger?(a+i, b+i, :downright) ? (return true) : (break if piece_same_color?(a+i, b+i))
      i += 1
    end
    #when :downleft
    i=1
    while a + i <=7 && b - i >= 0
      danger?(a+i, b-i, :downleft) ? (return true) : (break if piece_same_color?(a+i, b-i))
      i += 1
    end
    #when :upleft
    i=1
    while a - i >= 0 && b - i >= 0
      danger?(a-i, b-i, :upleft) ? (return true) : (break if piece_same_color?(a-i, b-i))
      i += 1
    end

    #check if a knight is putting
    return true if knight_check?(a, b)

    false
  end

  def knight_check?(a, b)

    @board.grid.each_with_index do |row, x|
      row.each_index do |y|
        if ((x - a).abs == 1 && (y - b).abs == 2) || ((x - a).abs == 2 && (y - b).abs == 1)
          return true if @board.get_piece([x,y]).is_a?(Knight)
        end
      end
    end

    false
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
