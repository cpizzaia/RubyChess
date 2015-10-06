require_relative "board"
require_relative "display"
require "byebug"




class Chess
  attr_reader :white_king, :black_king
  def initialize(board = Board.new)
    @board = board
    @black_king = @board.position([0,3])
    @white_king = @board.position([7,3])
    @display = Display.new
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
    if selected_piece.valid_move?(start_pos, finish_pos)

      a,b = start_pos
      x,y = finish_pos
      @board.grid[a][b] = nil
      @board.grid[x][y] = selected_piece

    end

    nil
  end


end

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
  while true
    game.move(game.play)
    if game.black_king.in_check?
      puts "IN CHECK"
      sleep(5)
    end

  end
end
