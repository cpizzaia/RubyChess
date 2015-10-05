require_relative "board"
require_relative "display"

x = Board.new
y = Display.new
z = nil
while z.nil?
  y.render(x)
  z = y.get_input
end
