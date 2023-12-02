require 'ostruct'
require 'pp'

source = File.readlines('input.txt').map(&:strip)
# source = [
#   'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
#   'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
#   'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
#   'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
#   'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'
# ]

COLOR_MAX = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

games = source.map do |line|
  md = line.match(/Game\s(\d+):\s(.*)\z/)
  rounds = md[2].split(';')
                .map.with_index do |round, idx|
                  pulls = round.scan(/(\d+)\s(\w+)/)
                               .map { |pull| OpenStruct.new(color: pull.last, quantity: pull.first.to_i) }
                  OpenStruct.new(round: idx+1, pulls: pulls)
                end

  OpenStruct.new(game: md[1].to_i, rounds: rounds, possible: false)
end

games.each do |game|
  game.possible = game.rounds
                      .all? do |round|
                        round.pulls.all? { |pull| pull.quantity <= COLOR_MAX[pull.color] }
                      end

end

possible_games = games.select(&:possible)
puts "Possible games #{possible_games.map(&:game).join(', ')}"
puts "Sum of possible games #{possible_games.reduce(0) { |sum, game| sum + game.game } }" 
