codes = File.readlines('./input.txt')

result = codes.reduce(0) do |sum, code|
  digits = code.scan(/\d/)
  sum + (digits.empty? ? 0 : (digits.first + digits.last).to_i)
end

puts "Sum of codes is #{result}"
