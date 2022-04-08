# frozen_string_literal: true

require 'yaml'
MESSAGES = YAML.load_file('mortgage_calc_prompts.yml')

def prompt(message)
  Kernel.puts("=> #{message}")
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

loop do
  # get loan amount from user
  loan_amount = ''
  loop do
    prompt(MESSAGES['loan_amount'])
    loan_amount = Kernel.gets.chomp

    if loan_amount.empty?
      prompt(MESSAGES['invalid_entry'])
    elsif loan_amount.to_f.negative?
      prompt(MESSAGES['invalid_number'])
    elsif valid_integer?(loan_amount) || valid_float?(loan_amount)
      break
    else
      prompt(MESSAGES['numeric_only'])
    end
  end

  # get annual interest rate from user
  annual_interest_rate = ''
  loop do
    prompt(MESSAGES['annual_interest_rate'])
    annual_interest_rate = Kernel.gets.chomp

    if annual_interest_rate.empty?
      prompt(MESSAGES['invalid_entry'])
    elsif annual_interest_rate.to_f.negative?
      prompt(MESSAGES['invalid_number'])
    elsif valid_integer?(annual_interest_rate) || valid_float?(annual_interest_rate)
      break
    else
      prompt(MESSAGES['numeric_only'])
    end
  end

  # get loan duration from user
  loan_duration_in_years = ''
  loop do
    prompt(MESSAGES['loan_duration'])
    loan_duration_in_years = Kernel.gets.chomp

    if loan_duration_in_years.empty?
      prompt(MESSAGES['invalid_entry'])
    elsif loan_duration_in_years.to_f.negative?
      prompt(MESSAGES['invalid_number'])
    elsif valid_integer?(loan_duration_in_years) || valid_float?(loan_duration_in_years)
      break
    else
      prompt(MESSAGES['numeric_only'])
    end
  end

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
