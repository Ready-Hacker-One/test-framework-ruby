class BankAccountService < ServiceBase

  USERS_URL = QaTestConfig.config['api_users_url'] + '/v0.1/users'

  def self.add_bank_account(user_id, country)
    bankAccount = Model::BankAccount.create_mock(country)
    base_post("#{USERS_URL}/#{user_id}/merchant-profile/bank-accounts", bankAccount)
  end
end