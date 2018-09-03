module Model
  class Address
    attr_accessor :address_line1, :address_line2, :city, :post_code, :region_id, :country, :landline

    def self.create_mock(country)
      address = Model::Address.new
      address.country = country
      address.address_line1 = "123\t#{StringGenerator.generate_special_string}"
      address.city = StringGenerator.generate_special_string
      address.post_code = generate_post_code(country)
      address.region_id = case country
                            when 'BR'
                              387
                            when 'US'
                              437 # California
                          end
      address
    end

    def self.create_mock_business(country)
      address = create_mock(country)
      address.landline = MockDataFactory.generate_phone_number(country)
      address
    end

    def self.generate_post_code(country)
      post_code = case country
                    when 'AT', 'BE', 'CH'
                      '1234'
                    when 'BR'
                      '20010-050'
                    when 'NL'
                      '9465 TN'
                    when 'PT'
                      '1234-012'
                    when 'GB'
                      'SW1A 1AA'
                    when 'IE'
                      nil
                    else
                      '12345'
                  end
      post_code
    end
  end
end
