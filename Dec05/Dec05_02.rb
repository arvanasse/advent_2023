require 'pp'
require 'ostruct'

source = File.readlines('input.txt').map(&:strip)
# source = [
#   'seeds: 79 14 55 13',
#   '',
#   'seed-to-soil map:',
#   '50 98 2',
#   '52 50 48',
#   '',
#   'soil-to-fertilizer map:',
#   '0 15 37',
#   '37 52 2',
#   '39 0 15',
#   '',
#   'fertilizer-to-water map:',
#   '49 53 8',
#   '0 11 42',
#   '42 0 7',
#   '57 7 4',
#   '',
#   'water-to-light map:',
#   '88 18 7',
#   '18 25 70',
#   '',
#   'light-to-temperature map:',
#   '45 77 23',
#   '81 45 19',
#   '68 64 13',
#   '',
#   'temperature-to-humidity map:',
#   '0 69 1',
#   '1 0 69',
#   '',
#   'humidity-to-location map:',
#   '60 56 37',
#   '56 93 4'
# ]

almanac = []
seeds = source.shift.scan(/\d+/).map(&:to_i)
source.shift

until source.empty?
  line = ''
  until line =~ /map/
    line = source.shift
  end

  puts line if md = line.match(/(\w+)\-to\-(\w+)\smap/)

  map = OpenStruct.new(source: md[1], dest: md[2], maps: [])
  almanac << map

  line = source.shift
  until line.empty? do
    if md = line.match(/(\d+)\s(\d+)\s(\d+)/)
      source_start = md[1].to_i
      dest_start = md[2].to_i
      length = md[3].to_i
      map.maps << OpenStruct.new(source: Range.new(source_start, source_start + length - 1),
                                 dest: Range.new(dest_start, dest_start + length - 1))
    end

    break if (line = source.shift).nil?
  end
end

locations = seeds.map.with_index do |seed, i|
  puts "Checking seed ##{i}: #{seed}"
  source = 'seed'
  source_location = seed

  destination = ''
  destination_location = -1

  until source == 'location' do
    map = almanac.find { |m| m.source == source }
    destination = map.dest
    puts "\tMapping #{source} to #{destination}"

    source_map = map.maps.find { |m| m.source.include? source_location } ||
      OpenStruct.new(source: [source_location], dest: [source_location])

    destination_location = source_map.dest.to_a[source_map.source.to_a.index source_location]

    source_location = destination_location
    source = destination
  end
  puts

  destination_location
end

pp locations
puts "The closest location is #{locations.min}"
