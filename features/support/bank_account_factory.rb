class BankAccountFactory

  BANK_ACCOUNT_COUNTRIES = %w(IE DE GB FR IT ES PT NL AT BE BR PL CH)
  ITALIAN_CONVERT = Hash[0 => 1, 1 => 0, 2 => 5, 3 => 7, 4 => 9, 5 => 13, 6 => 15, 7 => 17, 8 => 19, 9 => 21]
  CHECK_DIGIT = ("A".."Z").to_a
  LIST_NUMBER = (10..35).to_a
  INTERNATIONAL_CONVERT = Hash[CHECK_DIGIT.zip LIST_NUMBER]


  def bank_account(bank_country)
    unless BANK_ACCOUNT_COUNTRIES.include? bank_country
      raise "Unknown bank country: #{bank_country.to_s}. Allowed are #{BANK_ACCOUNT_COUNTRIES.to_s}"
    end
    result = nil
    rand = Random.new
    case bank_country
      when 'DE'
        first_part = (rand.rand(8999999) + 1000000).to_s
        first_part_sum = 0
        multiplier = 2
        6.downto(0) do |i|
          first_part_sum += first_part[i].to_i * multiplier
          multiplier += 1
        end
        check_digit = ((11 - (first_part_sum % 11)) % 11).to_s
        second_part = (rand.rand(89) + 10).to_i.to_s
        result = "#{first_part}#{check_digit}#{second_part}"
      when 'GB'
        account_number = (rand.rand(89999999) + 10000000).to_i
        sort_code = (rand.rand * 100000).to_i + 300000
        result = account_number, sort_code
      when 'IE'
        account_number = (rand.rand(89999999) + 10000000).to_i
        sort_code = 931152
        result = account_number, sort_code
      when 'IT'
        iban = generate_iban('IT')
        bic_swift = "#{"test"}IT#{"test1"}"
        result = iban, bic_swift
      when 'NL'
        account_factor = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
        begin
          rnd_number =  (rand.rand(8999999) + 1000000).to_s
          account_number = "000#{rnd_number}"
          accumulator = calculate_accumulator(account_number, account_factor)
        end while (accumulator % 11) != 0
        result = account_number
      when 'ES'
        bank_factor = [4, 8, 5, 10]
        branch_factor = [9, 7, 3, 6]
        account_factor = [1, 2, 4, 8, 5, 10, 9, 7, 3, 6]
        bank_code = "20#{(rand.rand(89) + 10)}"
        branch_code = "#{(rand.rand(8999) + 1000)}"
        account_number = "#{(rand.rand(8999999999) + 1000000000)}"
        sum = calculate_accumulator(bank_code, bank_factor) + calculate_accumulator(branch_code, branch_factor)
        check_1 = check_digit_spain(sum)
        accomulator = calculate_accumulator(account_number, account_factor)
        check_2 = check_digit_spain(accomulator)
        result = "#{bank_code}#{branch_code}", "#{check_1}#{check_2}", account_number
      when 'BE'
        begin
          first_part = (rand.rand(8999999999) + 1000000000)
          check_digit = first_part % 97
        end while check_digit == 0
        account_number = "#{first_part}00"
        result = account_number.to_i + check_digit
      when 'FR'
        sort_code = 30066
        branch_code = (rand.rand(89999) + 10000)
        account_number = (rand.rand(89999999999) + 10000000000)
        check_digit = 97 - ("#{sort_code}#{branch_code}#{account_number}00".to_i % 97)
        result = sort_code, branch_code, account_number, check_digit.to_s.rjust(2, '0')
      when 'PT'
        account_factor = [73, 17, 89, 38, 62, 45, 53, 15, 50, 5, 49, 34, 81, 76, 27, 90, 9, 30, 3]
        bank_code = "0035"
        branch_code = "0#{(rand.rand(899) + 100)}"
        account_number = (rand.rand(89999999999) + 10000000000)
        accomulator = calculate_accumulator("#{bank_code}#{branch_code}#{account_number}", account_factor)
        check = 98 - (accomulator % 97)
        result = bank_code, branch_code, account_number, check.to_s.rjust(2, '0')
      else
        raise "Unknown bank country: #{bank_country.to_s}."
    end
    return result
  end

  def generate_iban(nation)
    rand = Random.new
    abi = "00#{rand.rand(999).to_s}"
    rnd_number = rand.rand(99999999999999999).to_s
    rnd = "#{abi}#{rnd_number}"
    even = (1...rnd.size).step(2).collect { |i| rnd[i].to_i }.inject(&:+)
    odd = (0...rnd.size).step(2).collect { |i| ITALIAN_CONVERT[rnd[i].to_i] }.inject(&:+)
    italian_check = CHECK_DIGIT[(even + odd) % 26]
    int_check = check_digit(nation, italian_check, rnd)
    iban = "#{nation}#{int_check}#{italian_check}#{rnd}"
    return iban
  end

  def check_digit(nation, code, rnd)
    first = INTERNATIONAL_CONVERT[code]
    a = INTERNATIONAL_CONVERT[nation[0]]
    b = INTERNATIONAL_CONVERT[nation[1]]
    conv = "#{first}#{rnd}#{a}#{b}00".to_i
    return 98 - (conv % 97)
  end

  def calculate_accumulator(code,factor)
    len = 0
    accomulator = 0
    for i in (0..code.to_s.size-1)
      accomulator += code[i].to_i*(factor[len])
      len += 1
    end
    return accomulator
  end

  def check_digit_spain(value)
    check = 11 - (value % 11)
    check = 1 if check == 10
    check = 0 if check == 11
    return check
  end

end