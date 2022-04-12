# frozen_string_literal: true

def prompt(message)
  puts "\n=> #{message}"
  sleep 2
end

def win?(user, computer)
  (user == 'rock' && computer == 'scissors') ||
    (user == 'paper' && computer == 'rock') ||
    (user == 'scissors' && computer == 'paper')
end

def determine_game_outcome(user, computer)
  if win?(user, computer)
    'user'
  elsif win?(computer, user)
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

VALID_CHOICE = %w[rock paper scissors].freeze

play_again = ''
loop do
  user_choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICE}")
    user_choice = gets.chomp

    break if VALID_CHOICE.include?(user_choice)

    prompt('That was an invalid choice.')
  end

  computer_choice = VALID_CHOICE.sample

  prompt("You chose #{user_choice}, computer chose #{computer_choice}.")

  game_outcome = determine_game_outcome(user_choice, computer_choice)

  display_result(game_outcome)

  prompt('Do you want to play again?')
  play_again = gets.chomp

  break unless play_again.downcase.start_with?('y')

  system('clear')
end

prompt('Thank you for playing Rock, Paper, Scissors!')
prompt('Goodbye!')
