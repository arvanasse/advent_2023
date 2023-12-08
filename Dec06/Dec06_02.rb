require 'pp'
require 'ostruct'
require 'bigdecimal'
require 'bigdecimal/util'

  source = File.readlines('input.txt').map(&:strip)
# source = [
#   'Time:      7  15   30',
#   'Distance:  9  40  200'
# ]

races = source.map do |line|
  measure, values = line.split(':')

  value = values.strip
                .scan(/\s*\d+\s*/)
                .map(&:strip)
                .join
                .to_i

  { measure.downcase.to_sym  => value }
end.reduce(&:merge)

race = OpenStruct.new(races)

discriminant = Math.sqrt((race.time.to_d ** 2) - (race.distance.to_d * 4))
max = ((discriminant + race.time.to_d) / 2).floor
min = (((-1 * discriminant) + race.time.to_d) / 2).ceil

min += 1 if (min * (race.time - min)) == race.distance
max -= 1 if (max * (race.time - max)) == race.distance
ways = Range.new(min, max).size
puts "Number of ways to beat the record #{ways}"
