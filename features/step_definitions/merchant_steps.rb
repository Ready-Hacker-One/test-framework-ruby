module RegistrationStepsHarness
  def register_merchant(country)
    merchant = UserService.create_full_user_from_country(country)
    $sharedState.merchant = MerchantState.from_users_api_response(merchant)
    merchant_id = $sharedState.merchant.merchant_id
    user_id = $sharedState.merchant.user_id
    BankAccountService.add_bank_account(user_id, country)
    if country != 'BR'
      MobileVerificationsService.request_activation_code(user_id, merchant_id, country)
      activation = DB::Activation.find_by_merchant_id(merchant_id)
      MobileVerificationsService.activate(user_id, merchant_id, activation.code)
    end
    merchant
  end

  def login_merchant(username, password)
    login = AuthService.login_merchant(username, password)
    $sharedState.access_token = login.accesstoken
    $sharedState.merchant = MerchantState.from_auth_response(login)
  end
end
World(RegistrationStepsHarness)

Given(/^Active merchant from "(BR|DE|ES|GB)"/) do |country|
  register_merchant(country)
end

Given(/^Authenticated active merchant from "(BR|DE|ES|GB|US)"/) do |country|
  preset_merchants = QaTestConfig.config['preset_merchants']
  preset_merchant_email = preset_merchants[country] unless preset_merchants.blank?
  credentials =
      if preset_merchant_email.blank?
        register_merchant(country)
        $sharedState.merchant.email
      else
        preset_merchant_email
      end
  login_merchant(credentials, credentials)
end

Given 'merchant is logged in' do
  credentials = $sharedState.merchant.email
  login_merchant(credentials, credentials)
end