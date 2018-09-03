class Model::BankAccount
  attr_accessor :iban, :swift, :account_holder_name, :bank_code, :branch_code, :account_number, :check_digit, :account_type

  def self.create_mock(country)
    bank = Model::BankAccount.new
    bank.account_holder_name = 'Da BIG Bad Wolf'
    case country
      when 'BR'
        bank.bank_code = '356'
        bank.branch_code = '1234'
        bank.account_number = '123456'
        bank.check_digit = 'X'
        bank.account_type = 'CURRENT'
      when 'DE'
        bank.iban = 'DE23200100200012345673'
        bank.swift = 'PBNKDEFFXXX'
      when 'ES'
        bank.iban = 'ES1020903200500041045040'
        bank.swift = 'BSABESBBXXX'
      when 'GB'
        bank.bank_code = '123456'
        bank.account_number = '12345678'
      when 'US'
        bank.account_number = '031201360'
        bank.bank_code = '121122676'
        bank.account_type = 'CHECKING'
      else
        raise 'Bank not supported: ' + country
    end
    bank
  end
end
