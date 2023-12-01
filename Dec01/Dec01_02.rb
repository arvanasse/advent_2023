codes = File.readlines('./input.txt')

# codes = %w[ two1nine
#             eightwothree
#             abcone2threexyz
#             xtwone3four
#             4nineeightseven2
#             zoneight234
#             7pqrstsixteen]

DIGIT_CONVERSION = {
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
  line += 1
  orig = code.dup
  while (code =~ convert_any) do
    replacements = DIGIT_CONVERSION.reduce({}) do |h, (text, digit)|
      position = (code =~ text)
      position ? h.merge(position => text) : h
    end

    replacement = replacements[replacements.keys.sort.first]
    code.gsub!(replacement, DIGIT_CONVERSION[replacement])
    puts "#{line}: #{orig.strip} => #{code}" if replacements.keys.size > 0
  end

  digits = code.scan(/\d/)
  puts "#{line}: #{digits.first}#{digits.last}\n\n"
  sum + (digits.empty? ? 0 : (digits.first + digits.last).to_i)
end

puts "Sum of codes is #{result}"
