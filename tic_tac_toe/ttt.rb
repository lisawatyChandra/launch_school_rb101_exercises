require 'pry'

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze

def prompt(msg)
  puts "==> #{msg}"
end

def display_board(board)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}."
  puts ''
  puts '     |     |'
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}"
  puts '     |     |'
  puts '-----+-------+-----'
  puts '     |     |'
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}"
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}"
  puts '     |     |'
  puts ''
end

def initialize_board
  new_board = {}
  (1..9).each do |num|
    new_board[num] = INITIAL_MARKER
  end
  new_board
end
# the following method retrieves only
# those squares that are still empty
def empty_squares(board)
  board.keys.select do |num|
    board[num] == INITIAL_MARKER
  end
end

def player_places_piece!(board)
  square = ''
  loop do
    prompt "Choose a square (#{empty_squares(board).join(', ')}):"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)

    prompt "Sorry, that's not a valid choice."
  end

  board[square] = PLAYER_MARKER
end

def computer_places_piece!(board)
  square = empty_squares(board).sample
  board[square] = COMPUTER_MARKER
end

def board_full?(board)
  empty_squares(board).empty?
end

def someone_won?(board)
  !!detect_winner(board)
  # placing `!!` before any object 
  # turns the object into its 
  # boolean equivalent
end

def detect_winner(board)
  winning_lines = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ]

  winning_lines.each do |line|
    if board[line[0]] == PLAYER_MARKER &&
       board[line[1]] == PLAYER_MARKER &&
       board[line[2]] == PLAYER_MARKER
      return 'Player'
    elsif board[line[0]] == COMPUTER_MARKER &&
          board[line[1]] == COMPUTER_MARKER &&
          board[line[2]] == COMPUTER_MARKER
      return 'Computer'
    end
  end
  nil
end

# main loop
loop do
  # local variable `board` is initialized and
  # assigned to a Hash object with 9 key-value
  # pairs; each key indicates a position on a 
  # 3x3 board, each value indicates a MARKER:
  # an `'X'`, an `'O'`, or an empty space `' '`.
  board = initialize_board
  # here we initialize the state of the board, 
  # not the way the board display even though
  # `display_board` will use the initial state
  # of the board to mark every square on the board
  # with an empty space `' '`.

  loop do
    display_board(board)
    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    display_board(board)
    sleep(1)

    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  prompt 'Play again? (y or n)'
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt 'Thank you for playing Tic Tac Toe! Goodbye!'
