class Model::MerchantProfile
  attr_accessor :legal_type_id, :merchant_category_code, :company_name, :nature_and_purpose, :address

  def self.create_mock(country)
    profile = Model::MerchantProfile.new
    profile.legal_type_id = case country
                              when 'BR'
                                140
                              when 'DE'
                                13
                              when 'GB'
                                7
                              when 'US'
                                205
                              else
                                raise "Legal type not set for country: #{country}"
                            end
    profile.merchant_category_code = '7392'
    profile.nature_and_purpose = StringGenerator.generate_special_string
    profile.company_name = StringGenerator.generate_special_string
    profile.address = Model::Address.create_mock_business(country)
    profile
  end
end
