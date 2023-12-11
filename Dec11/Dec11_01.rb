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

expanding_universe = []
universe.each.with_index do |row, index|
  expanding_universe << row
  expanding_universe << row if empty_rows.include? index
end

expanded_universe = []
expanding_universe.transpose.each.with_index do |col, index|
  expanded_universe << col
  expanded_universe << col if empty_cols.include? index
end
expanded_universe = expanded_universe.transpose

galaxies = expanded_universe.flat_map.with_index do |row, index|
  next if row.all? { |char| char == '.' }
  row.map.with_index { |char, col| { row: index, col: col } if char == '#' }.compact
end.compact

distances = galaxies.flat_map.with_index do |galaxy, outer|
  galaxies[(outer + 1)..-1].map do |other|
    (galaxy[:row] - other[:row]).abs + (galaxy[:col] - other[:col]).abs
  end
end

puts "Total distance #{distances.reduce(&:+)}"
