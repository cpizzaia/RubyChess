require_relative "board"
require_relative "display"
require "byebug"




class Chess
  attr_reader :white_king, :black_king, :hypo_move
  def initialize(board = Board.new)

    @board = board
    @black_king = @board.position([0,4])
    @white_king = @board.position([7,4])
    @display = Display.new

    @hypo_move = []
    @game_over = false
  end

  def run
    until @game_over
      move(play)
      if black_king.in_check?
        check_mate?(:black) ? @game_over = true : nil
      end
      if white_king.in_check?
        check_mate?(:white) ? @game_over = true : nil
      end
    end
  end



  def play
    selected_piece = nil
    start_pos = nil
    finish_pos = nil
    while selected_piece.nil?
      @display.render(@board)
      puts "Select a piece"
      start_pos = @display.get_input
      if !start_pos.nil?
        selected_piece = @board.position(start_pos)
      end
    end

    while finish_pos.nil?
      @display.render(@board)
      puts "Select where to move"
      finish_pos = @display.get_input
    end

    return [start_pos, finish_pos, selected_piece]
  end

  def move(arr)
    start_pos, finish_pos, selected_piece = arr
    result = false



    if selected_piece.valid_move?(start_pos, finish_pos)
      @hypo_move = [start_pos, finish_pos, selected_piece, @board.get_piece(finish_pos)]
      a,b = start_pos
      x,y = finish_pos
      @board.grid[a][b] = nil
      @board.grid[x][y] = selected_piece
      result = true
    end

    result
  end

  def revert_move
    a,b = @hypo_move[0]
    x,y = @hypo_move[1]
    @board.grid[a][b] = @hypo_move[2]
    @board.grid[x][y] = @hypo_move[3]
  end

  def check_mate?(color)
    @board.grid.each_with_index do |row, a|
      row.each_with_index do |piece, b|
        if !piece.nil? && piece.color == color
          (0..7).each do |x|
            (0..7).each do |y|
              if move([[a,b], [x,y], piece ])
                if @black_king.in_check?
                  revert_move
                else
                  revert_move
                  return false
                end
              end
            end
          end
        end
      end
    end
    puts "CHECKMATE"
    sleep(5)
    true
  end



end

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
  game.run
end
