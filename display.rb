require_relative "cursorable"
require_relative "piece"

class Display
  include Cursorable




  def initialize
    @cursor_pos = [0,0]
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def render(board)

    system("clear")

    var = board.grid.map.with_index do |row, i|
      row.map.with_index do |column, j|
        if column.nil?
          "   ".colorize(what_color?(i, j))
        else
          column.show.colorize(what_color?(i, j))
        end
      end
    end
    puts  var.map {|row| row.join('') + "\n"}
  end

  def what_color?(i, j)
    x, y = @cursor_pos
    if x == i && y == j
      {background: :red}
    elsif (i+j).odd?
      {background: :white}
    else
      {background: :green}
    end
  end

end
