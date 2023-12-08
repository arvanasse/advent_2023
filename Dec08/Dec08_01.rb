require 'pp'
require 'ostruct'

source = File.readlines('input.txt').map(&:strip)

# source = [
#   'RL',
#   '',
#   'AAA = (BBB, CCC)',
#   'BBB = (DDD, EEE)',
#   'CCC = (ZZZ, GGG)',
#   'DDD = (DDD, DDD)',
#   'EEE = (EEE, EEE)',
#   'GGG = (GGG, GGG)',
#   'ZZZ = (ZZZ, ZZZ)'
# ]

# source = [
#   'LLR',
#   '',
#   'AAA = (BBB, BBB)',
#   'BBB = (AAA, ZZZ)',
#   'ZZZ = (ZZZ, ZZZ)'
# ]

turn_sequence = source.shift.chars.map { |c| c.downcase.to_sym }
source.shift if source.first.empty?

nodes = source.reduce({}) do |h, line|
  md = line.match(/(\w{3})\s\=\s\((\w{3})\,\s(\w{3})/)
  h.merge(md[1] => { l: md[2], r: md[3] })
end

current_node = 'AAA'
turn_index = 0
turn_sequences = turn_sequence.size

steps = 0
until current_node == 'ZZZ'
  current_node = nodes.dig(current_node, turn_sequence[turn_index])
  turn_index = (turn_index + 1) % turn_sequences
  steps += 1
end

puts "It took #{steps} steps"
