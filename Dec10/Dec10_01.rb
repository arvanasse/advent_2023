require 'pp'
require 'ostruct'

source = File.readlines('input.txt').map(&:strip)
# source = [
#   '.....',
#   '.S-7.',
#   '.|.|.',
#   '.L-J.',
#   '.....'
# ]

# source = [
#   '..F7.',
#   '.FJ|.',
#   'SJ.L7',
#   '|F--J',
#   'LJ...'
# ]

CONNECTIONS = {
  '|' => [[-1, 0], [1, 0]],
  '-' => [[0, -1], [0, 1]],
  'L' => [[-1, 0], [0, 1]],
  'J' => [[-1, 0], [0, -1]],
  '7' => [[1, 0], [0, -1]],
  'F' => [[1, 0], [0, 1]]
}

start = nil

source.each.with_index do |row, idx|
  next unless row.include?('S')
  start = OpenStruct.new(row: idx, col: row.index('S'))
end

routes = []
if (start.row > 0) && '|F7'.include?(source[start.row - 1][start.col])
  current = OpenStruct.new(row: start.row - 1, col: start.col) 
  routes << OpenStruct.new(prev: start, current: current)
end

if (start.row < source.size - 2) && '|LJ'.include?(source[start.row + 1][start.col])
  current = OpenStruct.new(row: start.row + 1, col: start.col)
  routes << OpenStruct.new(prev: start, current: current)
end

if (start.col > 0) && '-LF'.include?(source[start.row][start.col - 1])
  current = OpenStruct.new(row: start.row, col: start.col - 1)
  routes << OpenStruct.new(prev: start, current: current)
end

if (start.col < source.first.size) && '-J7'.include?(source[start.row][start.col + 1])
  current = OpenStruct.new(row: start.row, col: start.col + 1)
  routes << OpenStruct.new(prev: start, current: current)
end

steps = 1
until (routes.first.current.row == routes.last.current.row) && (routes.first.current.col == routes.last.current.col)
  steps += 1

  routes.each.with_index do |route, idx|
    pipe = source[route.current.row][route.current.col]

    move = CONNECTIONS[pipe].reject do |m|
      route.current.row + m.first == route.prev.row &&
        route.current.col + m.last == route.prev.col
    end.first

    route.prev = route.current.dup
    route.current.row += move[0]
    route.current.col += move[1]
  end
end
puts "The furthest point is #{steps} steps away"
