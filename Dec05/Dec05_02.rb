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
seeds = source.shift
              .scan(/(\d+)\s+(\d+)/)
              .map { |start, length| OpenStruct.new(range: Range.new(start.to_i, start.to_i + length.to_i - 1), offset: 0) }
              .sort { |a, b| a.first <=> b.first }
source.shift
pp seeds

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

source = 'seed'
destination = ''
source_ranges = seeds.sort { |a, b| a.range.first <=> b.range.first }
destination_ranges = []

until source == 'location' do
  map = almanac.find { |m| m.source == source }
  destination = map.dest

  destination_ranges = source_ranges.flat_map do |source_range|
    # puts "Source range #{source_range.inspect}"
    ranges = map.maps.map do |m|
      # puts "\tChecking range #{m}"
      next if m.range.last < source_range.range.first
      next if m.range.first > source_range.range.last

      min = [source_range.range.first, m.range.first].max
      max = [source_range.range.last, m.range.last].min

      # puts "Overlap from #{min} to #{max}"
      OpenStruct.new(range: Range.new(min, [source_range.range.last, m.range.last].min), offset: m.offset + source_range.offset)
    end.compact

    next source_range if ranges.empty?

    # Cover the gap that precedes the first mapped ranges
    if ranges.first.range.first < source_range.range.first
      ranges << OpenStruct.new(range: Range.new(source_range.range.first, ranges.first.first - 1), offset: source_range.offset)
    end

    # Cover the gap that follows the last mapped ranges
    if ranges.last.range.last < source_range.range.last
      ranges << OpenStruct.new(range: Range.new(ranges.last.range.last + 1, source_range.range.last), offset: source_range.offset)
    end

    gaps = ranges.sort { |a, b| a.range.first <=> b.range.first }
                 .map.with_index do |r, i|
                   next if i + 1 >= ranges.size
                   next if r.range.last - ranges[i + 1].range.first == 1
                   OpenStruct.new(range: Range.new(r.range.last + 1, ranges[i+1].range.first - 1), offset: source_range.offset)
                 end.compact

    ranges += gaps if gaps.any?
    ranges.sort! { |a, b| a.range.first <=> b.range.first }
  end
  pp destination_ranges
  gets

  source = destination
  source_ranges = destination_ranges
end

destination_ranges.each { |r| puts "Range #{r} has location #{r.range.first + r.offset}" }

min_locations = destination_ranges.map { |r| r.range.first + r.offset }.select { |val| val > 0 }
puts "The closest location is #{min_locations.min}"
