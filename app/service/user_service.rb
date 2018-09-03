class UserService < ServiceBase

  USERS_URL = QaTestConfig.config['api_users_url'] + '/v0.1/users'

  def self.create_full_user_from_country(country)
    raise 'Country cannot be null' unless country

    user = Model::User.new
    user.country = country
    user.credentials = Model::Credentials.create_mock
    user.personal_profile = Model::PersonalProfile.create_mock(country)
    user.merchant_profile = Model::MerchantProfile.create_mock(country)
    base_post(USERS_URL, user)
  end
end