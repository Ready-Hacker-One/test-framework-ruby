class Model::MobileVerification
  attr_accessor :merchant_id, :mobile_phone, :locale

  def initialize(merchant_id, mobile_phone)
    @merchant_id = merchant_id
    @mobile_phone = mobile_phone
    @locale = 'en-GB'
  end

  def self.create_mock(merchant_id, country)
    Model::MobileVerification.new(
        merchant_id,
        MockDataFactory.generate_mobile_phone_number(country))
  end
end