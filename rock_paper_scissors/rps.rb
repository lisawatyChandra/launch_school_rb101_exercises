# frozen_string_literal: true

def prompt(message)
  puts "\n=> #{message}"
end

def parse_user_choice(user_choice)
  case user_choice
  when 'r' then 'ROCK'
  when 'p' then 'PAPER'
  when 'sc' then 'SCISSORS'
  when 'l' then 'LIZARD'
  when 'sp' then 'SPOCK'
  end
end

WINNING_COMBINATIONS = {
  'ROCK' => %w[SCISSORS LIZARD],
  'PAPER' => %w[ROCK SPOCK],
  'SCISSORS' => %w[PAPER LIZARD],
  'LIZARD' => %w[SPOCK PAPER],
  'SPOCK' => %w[ROCK SCISSORS]
}.freeze

def determine_game_outcome(user, computer)
  if WINNING_COMBINATIONS[user].include?(computer)
    'user'
  elsif WINNING_COMBINATIONS[computer].include?(user)
    'computer'
  else
    'neither'
  end
end

def display_result(game_outcome)
  if game_outcome == 'user'
    puts 'You win!'
  elsif game_outcome == 'computer'
    puts 'Computer wins!'
  elsif game_outcome == 'neither'
    puts 'It\'s a tie!'
  end
end

USER_VALID_CHOICE = %w[r p sc l sp].freeze
COMPUTER_VALID_CHOICE = %w[ROCK PAPER SCISSORS].freeze

system('clear')

prompt('Welcome to Rock, Paper, Scissors, Lizard, and Spock!')

play_again = ''
loop do
  user_choice = ''
  loop do
    prompt('Choose one: [Rock, Paper, Scissors, Lizard, Spock]')
    prompt('Please type r for Rock, p for Paper, sc for Scissors, l for Lizard, sp for Spock')
    user_choice = gets.chomp

    break if USER_VALID_CHOICE.include?(user_choice)

    prompt('That was an invalid choice.')
  end

  user_choice = parse_user_choice(user_choice)
  computer_choice = COMPUTER_VALID_CHOICE.sample

  prompt("You chose #{user_choice}, computer chose #{computer_choice}.")

  game_outcome = determine_game_outcome(user_choice, computer_choice)

  display_result(game_outcome)

  prompt('Do you want to play again?')
  play_again = gets.chomp

  break unless play_again.downcase.start_with?('y')

  system('clear')
end

system('clear')

prompt('Thank you for playing Rock, Paper, Scissors!')
prompt('Goodbye!')
