require 'pp'

source = File.readlines('input.txt').map(&:strip)
# source = [
#   '0 3 6 9 12 15',
#   '1 3 6 10 15 21',
#   '10 13 16 21 30 45'
# ]

next_values = source.map do |line|
  pattern = [line.scan(/\-?\d+/).map(&:to_i)]

  until pattern[-1].all?(&:zero?) || pattern[-1].size == 1 do
    last = pattern[-1]
    differences = last.map.with_index do |val, i|
      next if i.zero?
      val - last[i-1]
    end.compact

    pattern << differences
  end

  pattern.reverse.reduce(0) { |val, row| val + row[-1] }
end

puts "Sum of extrapolated values is #{ next_values.reduce(&:+) }"
