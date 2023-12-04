require 'ostruct'
require 'pp'

  source = File.readlines('input.txt').map(&:strip)

# source = %w[
#   467..114..
#   ...*......
#   ..35..633.
#   ......#...
#   617*......
#   .....+.58.
#   ..592.....
#   ......755.
#   ...$.*....
#   .664.598..
# ]

number_positions = []
symbol_positions = []

source.each.with_index do |line, line_num|
  numbers = line.scan(/\d+/).reverse

  line.each_char.with_index do |_c, col_num|
    next if number_positions.any? && number_positions.last.row == line_num && (col_num < number_positions.last.col + number_positions.last.number.size)
    next if numbers.empty? || line[col_num, numbers.last.size] != numbers.last

    number = numbers.pop
    number_positions << OpenStruct.new(number: number, row: line_num, col: col_num)
  end

  line.each_char.with_index do |char, col_num|
    symbol_positions << OpenStruct.new(number: char, row: line_num, col: col_num) if char =~ /[^\d\.]/
  end
end

gears = symbol_positions.map do |symbol_position|
  adjacent_numbers = number_positions.select do |number_position|
    row_range = Range.new(number_position.row - 1, number_position.row + 1)
    col_range = Range.new(number_position.col - 1, number_position.col + number_position.number.size)
    row_range.include?(symbol_position.row) && col_range.include?(symbol_position.col)
  end

  adjacent_numbers if adjacent_numbers.size == 2
end.compact

gear_ratios = gears.map { |ratios| ratios.reduce(1) { |sum, num| sum * num.number.to_i } }

puts "There are #{gear_ratios.size} gears"
puts "Sum of Part Numbers #{gear_ratios.reduce(0) { |sum, ratio| sum + ratio } }"
