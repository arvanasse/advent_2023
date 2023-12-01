  codes = File.readlines('./input.txt')

# codes = %w[ two1nine
#             eightwothree
#             abcone2threexyz
#             xtwone3four
#             4nineeightseven2
#             zoneight234
#             7pqrstsixteen]

DIGIT_CONVERSION = {
  /oneight/ => '18',
  /twone/ => '21',
  /threeight/ => '38',
  /fiveight/ => '58',
  /sevenine/ => '79',
  /eightwo/ => '82',
  /eighthree/ => '83',
  /nineight/ => '98',
  /one/ => '1',
  /two/ => '2',
  /three/ => '3',
  /four/ => '4',
  /five/ => '5',
  /six/ => '6',
  /seven/ => '7',
  /eight/ => '8',
  /nine/ => '9',
}
convert_any = DIGIT_CONVERSION.keys.reduce { |res, test| Regexp.new("#{res}|#{test}") }

line = 0
result = codes.reduce(0) do |sum, code|
  DIGIT_CONVERSION.each_pair { |test, replacement| code.gsub!(test, replacement) }
  digits = code.scan(/\d/)
  sum + (digits.empty? ? 0 : (digits.first + digits.last).to_i)
end

puts "Sum of codes is #{result}"
