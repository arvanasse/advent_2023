require 'pp'

  source = File.readlines('input.txt')

# source = [
#   '...#......',
#   '.......#..',
#   '#.........',
#   '..........',
#   '......#...',
#   '.#........',
#   '.........#',
#   '..........',
#   '.......#..',
#   '#...#.....'
# ]

universe = source.map do |row|
  row.scan(/[\.#]/)
end

empty_rows = universe.map.with_index { |row, index| index if row.all? { |char| char == '.' } }.compact
empty_cols = universe.transpose.map.with_index { |col, index| index if col.all? { |char| char == '.' } }.compact

galaxies = universe.flat_map.with_index do |row, index|
  next if row.all? { |char| char == '.' }
  row.map.with_index { |char, col| { row: index, col: col } if char == '#' }.compact
end.compact

SCALE = 999_999
distances = galaxies.flat_map.with_index do |galaxy, outer|
  galaxies[(outer + 1)..-1].map do |other|
    original_distance = (galaxy[:row] - other[:row]).abs + (galaxy[:col] - other[:col]).abs

    expanding_distance = empty_rows.select do |row|
      endpoints = [galaxy[:row], other[:row]].sort
      endpoints.first <= row && row <= endpoints.last
    end.size

    expanding_distance += empty_cols.select do |col|
      endpoints = [galaxy[:col], other[:col]].sort
      endpoints.first <= col && col <= endpoints.last
    end.size

    original_distance + (expanding_distance * SCALE)
  end
end

puts "Total distance #{distances.reduce(&:+)}"
