class SharedState

  attr_accessor :merchant,
                :access_token

  def initialize
    @merchant = MerchantState.new
  end
end

class MerchantState
  attr_accessor :users_api_response, :auth_response

  def self.from_auth_response(auth_response)
    state = MerchantState.new
    state.auth_response = auth_response
    state
  end

  def self.from_users_api_response(users_response)
    state = MerchantState.new
    state.users_api_response = users_response
    state
  end

  def country
    users_response_country = @users_api_response.try(:merchant_profile).try(:address).try(:country)
    auth_response_country = @auth_response.try(:business).try(:country).try(:iso_code)
    auth_response_country || users_response_country
  end

  def email
    users_response_email = @users_api_response.try(:account).try(:username)
    auth_response_email = @auth_response.try(:result).try(:user).try(:email)
    users_response_email || auth_response_email
  end

  def merchant_id
    mid = @users_api_response.try(:merchant_profile).try(:id)
    raise 'No MID found (from Users API response)' unless mid
    mid
  end

  def user_id
    uid = @users_api_response.try(:id)
    raise 'No User ID found (from Users API response)' unless uid
    uid
  end
end
