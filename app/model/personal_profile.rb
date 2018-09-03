class Model::PersonalProfile
  attr_accessor :first_name, :last_name, :date_of_birth, :address, :national_id

  def self.create_mock(country)
    profile = Model::PersonalProfile.new
    profile.first_name = 'automationTest' + StringGenerator.generate_special_string(6)
    profile.last_name = 'automationTest' + StringGenerator.generate_special_string(6)
    profile.date_of_birth = '1980-01-01'
    profile.address = Model::Address.create_mock(country)
    profile.national_id = case country
                            when 'BR'
                              '000.000.000-00'
                            when 'US'
                              '111-22-3333'
                          end
    profile
  end
end
