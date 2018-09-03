module MockDataFactory
  def self.generate_phone_number(country)
    phone_number = case country
                     when 'DE'
                       '004915000000000'
                     when 'GB'
                       '01000000000'
                     when 'CH'
                       '0041740000000'
                     when 'FR'
                       '0033600000000'
                     when 'IT'
                       '00393000000000'
                     when 'ES'
                       '0034516273000'
                     when 'PT'
                       '00351900000000'
                     when 'NL'
                       '0031600000000'
                     when 'AT'
                       '00436000'
                     when 'BE'
                       '0032400000000'
                     when 'BR'
                       # '(11) 2000-00000'
                       '(10) 6123-4567'
                     when 'PL'
                       '0048500000000'
                     when 'IE'
                       '00353830000000'
                     when 'US'
                       '2345678910'
                     else
                       raise 'Invalid country for phone generation: ' + country
                   end
    phone_number
  end

  def self.generate_mobile_phone_number(country)
    phone_number = case country
                     when 'BR'
                       '(12) 30000000'
                     when 'DE'
                       '017100000000'
                     when 'GB'
                       '07800000000'
                     when 'US'
                       '2345678910'
                     else
                       raise 'Invalid country for phone generation: ' + country
                   end
    phone_number
  end
end
