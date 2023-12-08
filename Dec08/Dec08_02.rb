require 'pp'
require 'ostruct'

  source = File.readlines('input.txt').map(&:strip)

# source = [
#   'LR',
#   '',
#   '11A = (11B, XXX)',
#   '11B = (XXX, 11Z)',
#   '11Z = (11B, XXX)',
#   '22A = (22B, XXX)',
#   '22B = (22C, 22C)',
#   '22C = (22Z, 22Z)',
#   '22Z = (22B, 22B)',
#   'XXX = (XXX, XXX)'
# ]

turn_sequence = source.shift.chars.map { |c| c.downcase.to_sym }
source.shift if source.first.empty?

nodes = source.reduce({}) do |h, line|
  md = line.match(/(\w{3})\s\=\s\((\w{3})\,\s(\w{3})/)
  h.merge(md[1] => { l: md[2], r: md[3] })
end

current_nodes = nodes.keys.select { |node| node[-1] == 'A' }

turn_index = 0
turn_sequences = turn_sequence.size

steps = 0
until current_nodes.all? { |node| node[-1] == 'Z' }
  current_nodes = current_nodes.map do |node|
    nodes.dig(node, turn_sequence[turn_index])
  end

  turn_index = (turn_index + 1) % turn_sequences
  steps += 1
end

puts "It took #{steps} steps"
