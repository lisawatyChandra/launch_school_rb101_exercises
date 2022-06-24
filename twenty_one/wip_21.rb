require 'pry'

SUITS = %w(♥ ♦ ♣ ♠)
VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == 'A'
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == 'A' }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def string_of_hand(cards)
  # hand_array = []
  # 0.upto(cards.size - 1) do |i|
  #   hand_array += [cards[i].join]
  # end
  # hand_array.join(', ')
  cards.map do |card|
    card.join
  end.join(', ')
end

def busted?(total)
  total > 21
end

def detect_round_winner(player_total, dealer_total)
  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif player_total > dealer_total
    :player
  elsif player_total < dealer_total
    :dealer
  else
    :tie
  end
end

def declare_round_winner(player_total, dealer_total)
  result = detect_round_winner(player_total, dealer_total)

  case result
  when :player_busted
    puts "Player busted! Dealer wins!"
  when :dealer_busted
    puts "Dealer busted! Player wins!"
  when :player
    puts "Player wins!"
  when :dealer
    puts "Dealer wins!"
  else
    puts "It's a tie!"
  end
end

def play_again?
  puts "**************************************"
  puts "Would you like to play again? (y or n)"
  puts "**************************************"
  answer = gets.chomp
  sleep 0.25
  answer.downcase.start_with?('y')
end

def display_both_hands(player_cards, dealer_cards, player_total, dealer_total)
  puts ''
  puts "Dealer has: #{string_of_hand(dealer_cards)} "
    .concat("for a total of #{dealer_total}")
  puts ''
  puts "Player has: #{string_of_hand(player_cards)} "
    .concat("for a total of #{player_total}")
end

def display_round_results(round_state)
  puts ''
  puts "Round #{round_state[:rounds]} scores: "
    .concat("PLAYER - #{round_state[:player]}, ")
    .concat("DEALER - #{round_state[:dealer]}")
  puts ''
  puts "**************************************"
end

def declare_grand_winner(round_state)
  if round_state[:dealer] >= 5
    puts "After #{round_state[:rounds]} rounds, Dealer has won five times!"
  elsif round_state[:player] >= 5
    puts "After #{round_state[:rounds]} rounds, Player has won five times!"
  end
end

def grandwinner?(round_state)
  round_state[:player] >= 5 || round_state[:dealer] >= 5
end

def reset(round_state)
  round_state[:rounds] = 1
  round_state[:player] = 0
  round_state[:dealer] = 0
end

def enter_to_continue_and_increment_rounds(round_state)
  round_state[:rounds] += 1
  puts "Press Enter to continue: "
  gets
end

# main loop
round_state = { rounds: 1, player: 0, dealer: 0 }

puts "******************************"
puts "*   Welcome to Twenty-One    *"
puts "******************************"
sleep 2
puts "First player to win five rounds wins the game."
sleep 3

loop do
  system 'clear'
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  puts "player cards: #{player_cards[0].join}, #{player_cards[1].join}"
  puts "dealer_cards: #{dealer_cards[0].join} and ?"
  puts ''

  # player turn
  loop do
    puts "Player turn..."
    player_turn = nil
    loop do
      puts "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      puts "Sorry, must enter 'h' or 's'"
    end

    if player_turn == 'h'
      puts "You chose to hit!"
      player_cards << deck.pop
      puts "player cards are now: #{string_of_hand(player_cards)}"
      player_total = total(player_cards)
    end

    break if player_turn == 's' || busted?(player_total)
  end

  if busted?(player_total)
    round_state[:dealer] += 1
    display_both_hands(player_cards, dealer_cards, player_total, dealer_total)
    puts ''
    declare_round_winner(player_total, dealer_total)
    display_round_results(round_state)

    if grandwinner?(round_state)
      declare_grand_winner(round_state)
      reset(round_state)
      play_again? ? next : break
    elsif enter_to_continue_and_increment_rounds(round_state)
      next
    end
  else
    puts "You chose to stay at #{player_total}"
  end

  # dealer turn
  puts ''
  loop do
    break if dealer_total >= 17
    puts "Dealer turn..."
    puts "Dealer hits!"
    dealer_cards << deck.pop
    puts "Dealer cards are now: #{string_of_hand(dealer_cards)}"
    dealer_total = total(dealer_cards)
    sleep 3.5
  end

  if busted?(dealer_total)
    round_state[:player] += 1
    display_both_hands(player_cards, dealer_cards, player_total, dealer_total)
    puts ''
    declare_round_winner(player_total, dealer_total)
    display_round_results(round_state)

    if grandwinner?(round_state)
      declare_grand_winner(round_state)
      reset(round_state)
      play_again? ? next : break
    elsif enter_to_continue_and_increment_rounds(round_state)
      next
    end
  else
    puts "Dealer stays at #{dealer_total}"
  end

  # both player and dealer stays; compare cards
  display_both_hands(player_cards, dealer_cards, player_total, dealer_total)

  round_result = detect_round_winner(player_total, dealer_total)
  case round_result
  when :player then round_state[:player] += 1
  when :dealer then round_state[:dealer] += 1
  end

  puts ''
  declare_round_winner(player_total, dealer_total)
  display_round_results(round_state)

  if grandwinner?(round_state)
    declare_grand_winner(round_state)
    reset(round_state)
    break unless play_again?
  else
    enter_to_continue_and_increment_rounds(round_state)
  end
end

puts ''
puts "Thank you for playing Twenty-One. Goodbye!"
