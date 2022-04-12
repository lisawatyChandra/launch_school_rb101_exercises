# frozen_string_literal: true

def prompt(message)
  puts "\n=> #{message}"
end

def ask_user_choice
  user_choice = ''
  loop do
    prompt('Choose one: [Rock, Paper, Scissors, Lizard, Spock]')
    prompt('Please type r for Rock, p for Paper, sc for Scissors, l for Lizard, sp for Spock')
    user_choice = gets.chomp

    break if USER_VALID_CHOICE.include?(user_choice)

    prompt('That was an invalid choice.')
    sleep(2)
    system('clear')
  end
  user_choice
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

def outcome_each_round(user, computer)
  if WINNING_COMBINATIONS[user].include?(computer)
    'user'
  elsif WINNING_COMBINATIONS[computer].include?(user)
    'computer'
  else
    'neither'
  end
end

def display_scoreboard(scoreboard)
  prompt("You scored: #{scoreboard[:user]}, Computer scored: #{scoreboard[:computer]}")
end

def update_score(scoreboard, outcome_each_round)
  if outcome_each_round == 'user'
    scoreboard[:user] += 1
  elsif outcome_each_round == 'computer'
    scoreboard[:computer] += 1
  end
end

def match_over?(scoreboard)
  if scoreboard[:user] == 3 || scoreboard[:computer] == 3
    true
  else
    false
  end
end

def display_round_winner(game_outcome)
  if game_outcome == 'user'
    puts 'You win!'
  elsif game_outcome == 'computer'
    puts 'Computer wins!'
  elsif game_outcome == 'neither'
    puts 'It\'s a tie!'
  end
end

def display_grand_winner(scoreboard)
  if scoreboard[:user] == 3
    prompt("You've won with a score of #{scoreboard[:user]} to #{scoreboard[:computer]}!")
  else
    prompt("Computer have won with a score of #{scoreboard[:computer]} to #{scoreboard[:user]}!")
  end
  scoreboard[:user] = 0
  scoreboard[:computer] = 0
  sleep(3)
end

# main program
USER_VALID_CHOICE = %w[r p sc l sp].freeze
COMPUTER_VALID_CHOICE = %w[ROCK PAPER SCISSORS].freeze
scoreboard = { user: 0, computer: 0 }

system('clear')

prompt('Welcome to Rock, Paper, Scissors, Lizard, and Spock!')
sleep(2)

play_again = ''
loop do
  system('clear')
  loop do
    user_choice = parse_user_choice(ask_user_choice)
    computer_choice = COMPUTER_VALID_CHOICE.sample
    prompt("You chose #{user_choice}, computer chose #{computer_choice}.")
    round_outcome = outcome_each_round(user_choice, computer_choice)
    display_round_winner(round_outcome)
    update_score(scoreboard, round_outcome)

    display_scoreboard(scoreboard)
    match_over = match_over?(scoreboard)
    display_grand_winner(scoreboard) if match_over?(scoreboard)
    break if match_over

    sleep(2)
    system('clear')
  end

  prompt('Do you want to play again?')
  play_again = gets.chomp

  break unless play_again.downcase.start_with?('y')
end

system('clear')

prompt('Thank you for playing Rock, Paper, Scissors!')
prompt('Goodbye!')
