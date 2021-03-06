# frozen_string_literal: true

USER_VALID_CHOICE = %w[r p sc l sp].freeze
COMPUTER_VALID_CHOICE = %w[ROCK PAPER SCISSORS].freeze
WINNING_COMBINATIONS = {
  'ROCK' => { 'SCISSORS' => 'crushes', 'LIZARD' => 'crushes' },
  'PAPER' => { 'ROCK' => 'covers', 'SPOCK' => 'disproves' },
  'SCISSORS' => { 'PAPER' => 'cuts', 'LIZARD' => 'decapitates' },
  'LIZARD' => { 'SPOCK' => 'poisons', 'PAPER' => 'eats' },
  'SPOCK' => { 'ROCK' => 'vaporizes', 'SCISSORS' => 'smashes' }
}.freeze

def prompt(message)
  puts "\n=> #{message}"
end

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
def play(round, scoreboard)
  loop do
    display_scoreboard(round, scoreboard)
    user_choice = parse_user_choice(ask_user_choice)
    computer_choice = COMPUTER_VALID_CHOICE.sample
    prompt("You chose #{user_choice}, " \
    "computer chose #{computer_choice}.")
    round_outcome = outcome_each_round(user_choice, computer_choice)
    comment_each_round(user_choice, computer_choice)
    round += 1
    display_round_winner(round_outcome)
    update_score(scoreboard, round_outcome)
    match_over = match_over?(scoreboard)
    sleep(2)
    break if match_over

    sleep(2)
    system('clear')
  end

  display_scoreboard(round, scoreboard)
  display_grand_winner(round, scoreboard) if match_over?(scoreboard)
  sleep(3)
  system('clear')
end

def ask_user_choice
  user_choice = ''
  loop do
    prompt('Choose one: [Rock, Paper, Scissors, Lizard, Spock]')
    prompt(<<~ARG)
      Please type:
          r  for Rock, 
          p  for Paper, 
          sc for Scissors,
          l  for Lizard, 
          sp for Spock
    ARG
    user_choice = gets.chomp
    break if USER_VALID_CHOICE.include?(user_choice)

    prompt('That was an invalid choice.')
    sleep(2)
  end
  user_choice
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize

def parse_user_choice(user_choice)
  case user_choice
  when 'r' then 'ROCK'
  when 'p' then 'PAPER'
  when 'sc' then 'SCISSORS'
  when 'l' then 'LIZARD'
  when 'sp' then 'SPOCK'
  end
end

def outcome_each_round(user, computer)
  if WINNING_COMBINATIONS[user].keys.include?(computer)
    'user'
  elsif WINNING_COMBINATIONS[computer].keys.include?(user)
    'computer'
  else
    'neither'
  end
end

def comment_each_round(user_choice, computer_choice)
  user_wins = WINNING_COMBINATIONS[user_choice][computer_choice]
  computer_wins = WINNING_COMBINATIONS[computer_choice][user_choice]

  if outcome_each_round(user_choice, computer_choice) == 'user'
    prompt("#{user_choice} #{user_wins} #{computer_choice}!")
  elsif outcome_each_round(user_choice, computer_choice) == 'computer'
    prompt("#{computer_choice} #{computer_wins} #{user_choice}!")
  end
end

def display_round_winner(game_outcome)
  if game_outcome == 'user'
    prompt('You win!')
  elsif game_outcome == 'computer'
    prompt('Computer wins!')
  elsif game_outcome == 'neither'
    prompt('It\'s a tie!')
  end
end

def display_scoreboard(round, scoreboard)
  prompt("Round: #{round}")
  prompt("You scored: #{scoreboard[:user]}, " \
  " Computer scored: #{scoreboard[:computer]}")
  prompt('====================================' \
  '=======================================')
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

def display_grand_winner(round, scoreboard)
  if scoreboard[:user] == 3
    prompt("After #{round} rounds, you've won with a " \
    " score of #{scoreboard[:user]} to #{scoreboard[:computer]}!")
  else
    prompt("After #{round} rounds, computer have won with " \
    " a score of #{scoreboard[:computer]} to #{scoreboard[:user]}!")
  end
  scoreboard[:user] = 0
  scoreboard[:computer] = 0
  sleep(5)
end

# main program
system('clear')

prompt('Welcome to Rock, Paper, Scissors, Lizard, and Spock!')
sleep(3)

play_again = ''
loop do
  system('clear')
  round = 0
  scoreboard = { user: 0, computer: 0 }
  play(round, scoreboard)

  prompt('Do you want to play again? Type \'Y\' if yes')
  play_again = gets.chomp
  sleep(1)
  break unless play_again.downcase.start_with?('y')
end

system('clear')

prompt('Thank you for playing Rock, Paper, Scissors, Lizard, Spock!')
prompt('Goodbye!')
