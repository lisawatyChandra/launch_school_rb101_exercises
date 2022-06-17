# frozen_string_literal: true

require 'yaml'
require 'pry'
MESSAGES = YAML.load_file('mortgage_calc_prompts.yml')

def prompt(message)
  Kernel.puts("=> #{message}")
end

def get_input(key)
  input = ''
  loop do
    prompt(MESSAGES[key])
    input = Kernel.gets.chomp

    if input.empty?
      prompt(MESSAGES['invalid_entry'])
    elsif input.to_f.negative?
      prompt(MESSAGES['invalid_number'])
    elsif valid_integer?(input) || valid_float?(input)
      break
    else
      prompt(MESSAGES['numeric_only'])
    end
  end
  input
end

def valid_integer?(num)
  num.to_i.to_s == num
end

def valid_float?(num)
  num.to_f.to_s == num
end

def calculate_monthly_payment(
  loan_amount,
  annual_interest_rate,
  loan_duration_in_years
)
  loan_amount = loan_amount.to_f
  annual_interest_rate = annual_interest_rate.to_f / 100
  monthly_interest_rate = annual_interest_rate / 12
  loan_duration_in_months = loan_duration_in_years.to_f * 12
  loan_amount * (monthly_interest_rate / (
    1 - (1 + monthly_interest_rate)**-loan_duration_in_months)
                )
end

prompt(MESSAGES['welcome'])

# main loop
loop do
  loan_amount = get_input('loan_amount')

  annual_interest_rate = get_input('annual_interest_rate')

  loan_duration_in_years = get_input('loan_duration')

  monthly_payment = calculate_monthly_payment(
    loan_amount,
    annual_interest_rate,
    loan_duration_in_years
  )

  prompt("Your monthly payment is $#{format('%.2f', monthly_payment)}")

  prompt(MESSAGES['perform_another'])
  answer = Kernel.gets.chomp.downcase
  break unless answer.start_with?('y')
end

prompt(MESSAGES['thank_you'])
prompt(MESSAGES['good_bye'])
