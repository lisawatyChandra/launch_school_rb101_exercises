def prompt(message)
  puts "\n=> #{message}"
  sleep 2
end

def determine_game_outcome(user, computer)
  if (user == 'rock' && computer == 'scissors') || 
    (user == 'paper' && computer == 'rock') || 
    (user == 'scissors' && computer == 'paper')
    return 'user'
  elsif (user == 'scissors' && computer == 'rock') || 
    (user == 'rock' && computer == 'paper') || 
    (user == 'paper' && computer == 'scissors')
    return 'computer'
  else
    return "neither"
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

VALID_CHOICE = ['rock', 'paper', 'scissors']

play_again = ''
loop do
  user_choice = ''
  loop do
    prompt("Choose one: rock, paper, scissors")
    user_choice = gets.chomp

    break if VALID_CHOICE.include?(user_choice)
    prompt("That was an invalid choice.")
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

prompt("Thank you for playing Rock, Paper, Scissors!")
prompt("Goodbye!")