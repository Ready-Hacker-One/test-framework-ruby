# encoding: UTF-8

class AddressFactory

  ALPHABET = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  EXTENDED_ALPHABET = %w(à ê í õ ß Ä Ů Ž Ç)
  COUNTRIES =%w(IE DE GB FR IT ES PT NL AT BE BR PL CH)
  MERCHANT_CATEGORIES= {
      'DE' => '22',
      'GB' => '7',
      'CH' => '167',
      'FR' => '73',
      'IT' => '70',
      'ES' => '33',
      'PT' => '80',
      'NL' => '57',
      'AT' => '24',
      'BE' => '91',
      'BR' => '140',
      'PL' => '153',
      'IE' => '1'
  }

  def self.mobile_phone(country)
    phone_number = case country
      when 'ES'
        '06790000000'
      else
        raise 'Invalid country for mobile phone generation: ' + country
    end
  end

  def self.generate_national_id(country)
    national_id = case country
      when 'ES'
        'X2017373C'
      when 'IT'
        'TST TTD 90A41 F205B'
      when 'PL'
        '90010112349'
      else
        nil
    end
  end

  def self.generate_random_string(length = 10, include_special_chars = false)
    result = (0...length).map { ALPHABET[rand(ALPHABET.length)] }.join
    if include_special_chars
      result[rand(result.length)] = EXTENDED_ALPHABET[rand(EXTENDED_ALPHABET.length)]
    end
    result
  end

  def self.generate_random_country
    country = COUNTRIES[rand(COUNTRIES.length)]
    return country
  end
end

