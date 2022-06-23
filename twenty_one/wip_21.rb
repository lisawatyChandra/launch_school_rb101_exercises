require 'pry'

SUITS = %w(H D S C)
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

def busted?(total)
  total > 21
end

def detect_result(player_total, dealer_total)
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

def display_results(player_cards, dealer_cards)
  result = detect_result(player_cards, dealer_cards)

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
  answer.downcase.start_with?('y')
end

def compare_cards(player_cards, dealer_cards,player_total, dealer_total)
  puts '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  puts "Dealer has #{dealer_cards} for a total of #{dealer_total}"
  puts "Player has #{player_cards} for a total of #{player_total}"
  puts '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
end

# main loop
round_state = {player: 0, dealer: 0}
loop do
  system 'clear'
  puts "at the top of the main loop: #{round_state}"
  puts "*******************************"
  puts "~~~ Welcome to a game of 21 ~~~"
  puts "*******************************"
  puts ''

  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  puts "player cards: #{player_cards}"
  player_total = total(player_cards)
  puts "player count: #{player_total}"
  puts "dealer_cards: #{dealer_cards[0]} and ?"
  dealer_total = total(dealer_cards)
  puts "dealer count: #{dealer_total}"

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
      puts "player cards are now: #{player_cards}"
      player_total = total(player_cards)
      puts "player count is now: #{player_total}"
    end

    break if player_turn == 's' || busted?(player_total)
  end

  puts ''
  if busted?(player_total)
    round_state[:dealer] += 1    
    compare_cards(player_cards, dealer_cards, player_total, dealer_total)
    display_results(player_total, dealer_total)
    puts ''
    puts "at player busted: #{round_state}"
    sleep 3

    if round_state[:dealer] >= 5
      puts "Dealer is the Grandwinner!"
      if play_again?
        round_state[:player] = 0
        round_state[:dealer] = 0
      else
        break
      end
    end
  
    if round_state[:player] >= 5
      puts "Player is the Grandwinner!"
      if play_again?
        round_state[:player] = 0
        round_state[:dealer] = 0
      else
        break
      end
    end

    next
  else
    puts "You chose to stay at #{player_total}"
  end

  # dealer turn
  loop do
    break if dealer_total >= 17
    puts "Dealer turn..."
    puts "Dealer hits!"
    dealer_cards << deck.pop
    puts "Dealer cards are now: #{dealer_cards}"
    dealer_total = total(dealer_cards)
    puts "Dealer count is now: #{dealer_total}"
  end

  puts ''
  if busted?(dealer_total)
    round_state[:player] += 1
    compare_cards(player_cards, dealer_cards, player_total, dealer_total)
    display_results(player_total, dealer_total)
    puts ''
    puts "at dealer busted: #{round_state}"
    sleep 3

    if round_state[:dealer] >= 5
      puts "Dealer is the Grandwinner!"
      if play_again?
        round_state[:player] = 0
        round_state[:dealer] = 0
      else
        break
      end
    end
  
    if round_state[:player] >= 5
      puts "Player is the Grandwinner!"
      if play_again?
        round_state[:player] = 0
        round_state[:dealer] = 0
      else
        break
      end
    end

    next
  else
    puts "Dealer stays at #{dealer_total}"
    puts ''
  end

  # both player and dealer stays; compare cards
  compare_cards(player_cards, dealer_cards, player_total, dealer_total)

  round_result = detect_result(player_total, dealer_total)
  case round_result
  when :player then round_state[:player] += 1
  when :dealer then round_state[:dealer] += 1
  end
  

  puts ''
  display_results(player_total, dealer_total)

  puts ''
  puts "at the bottom of the main loop: #{round_state}"
  sleep 3
  puts ''
  puts "*****************************"

  if round_state[:dealer] >= 5
    puts "Dealer is the Grandwinner!"
    if play_again?
      round_state[:player] = 0
      round_state[:dealer] = 0
    else
      break
    end
  end

  if round_state[:player] >= 5
    puts "Player is the Grandwinner!"
    if play_again?
      round_state[:player] = 0
      round_state[:dealer] = 0
    else
      break
    end
  end
end

puts ''
puts "Thank you for playing!"
