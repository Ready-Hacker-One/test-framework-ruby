class MobileVerificationsService < ServiceBase
  MOBILE_VERIFICATIONS_URL = QaTestConfig.config['api_risk_url'] + '/v0.1/risk-profiles'

  def self.request_activation_code(user_id, merchant_id, country)
    vrf = Model::MobileVerification.create_mock(merchant_id, country)
    base_post("#{MOBILE_VERIFICATIONS_URL}/#{user_id}/mobile-verifications", vrf)
  end

  def self.activate(user_id, merchant_id, activation_code)
    activation = Model::Activation.new(activation_code)
    base_post("#{MOBILE_VERIFICATIONS_URL}/#{user_id}/activate?merchant_id=#{merchant_id}", activation)
  end
end