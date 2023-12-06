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

  md = line.match(/(\w+)\-to\-(\w+)\smap/)
  map = OpenStruct.new(source: md[1], dest: md[2], maps: [])
  almanac << map

  line = source.shift
  until line.empty? do
    if md = line.match(/(\d+)\s(\d+)\s(\d+)/)
      map.maps << OpenStruct.new(range: Range.new(md[2].to_i, md[2].to_i + md[3].to_i - 1), offset: md[1].to_i - md[2].to_i)
    end
    break if (line = source.shift).nil?
  end
end

almanac.each { |map| map.maps = map.maps.sort { |a, b| a.range.first <=> b.range.first } }

locations = seeds.map.with_index do |seed, i|
  puts "Checking seed ##{i}: #{seed}"
  source = 'seed'
  source_location = seed

  destination = ''
  destination_location = -1

  until source == 'location' do
    map = almanac.find { |m| m.source == source }
    destination = map.dest
    # puts "\tMapping #{source} #{source_location} to #{destination}"

    source_map = map.maps.find do |m|
      # puts "\t\tChecking #{m.inspect} #{m.range.include?(source_location)}"
      break if m.range.first > source_location
      m.range.include?(source_location)
    end

    source_map ||= OpenStruct.new(source: source_location, offset: 0, length: 1)
    # puts "\t\t#{source_map}"

    destination_location = source_location + source_map.offset
    puts "\t\tMapped to #{destination_location}"

    source_location = destination_location
    source = destination
  end

  destination_location
end

pp locations
puts "The closest location is #{locations.min}"
