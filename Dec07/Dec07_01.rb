require 'pp'
require 'ostruct'

source = File.readlines('input.txt').map(&:strip)
# source = [
#   '32T3K 765',
#   'T55J5 684',
#   'KK677 28',
#   'KTJJT 220',
#   'QQQJA 483'
# ]

card_values = %w[2 3 4 5 6 7 8 9 T J Q K A]

hand_strength = [
  { 1 => 5 },
  { 2 => 1, 1 => 3 },
  { 2 => 2, 1 => 1 },
  { 3 => 1, 1 => 2 },
  { 3 => 1, 2 => 1 },
  { 4 => 1, 1 => 1 },
  { 5 => 1 }
]

hands = source.map do |line|
  md = line.match(/([#{card_values.join}]{5})\s+(\d+)\z/)
  cards = md[1]
  bet = md[2].to_i
  first_card_strength = card_values.index(cards[0])

  grouped = Hash.new(0)
  cards.each_char { |c| grouped[c] += 1 }


  match_counts = grouped.reduce({}) { |h, (k, v)| h[v] ||= []; h.merge(v => h[v].push(k)) }
                        .reduce({}) { |h, (k, v)| h.merge(k => v.size) }

  strength = hand_strength.index(match_counts)

  OpenStruct.new(cards: cards, bet: bet, grouped: grouped, match_counts: match_counts, strength: strength)
end.sort do |a, b|
  if a.strength == b.strength
    idx = 0
    while (a.cards[idx] == b.cards[idx]) && idx < a.cards.size
      idx += 1
    end
    card_values.index(a.cards[idx]) <=> card_values.index(b.cards[idx])
  else
    a.strength <=> b.strength
  end
end

hands.each.with_index do |hand, i|
  hand[:score] = hand.bet * (i + 1)
end

puts "The total winnings = #{hands.reduce(0) { |sum, hand| sum + hand.score}}"
