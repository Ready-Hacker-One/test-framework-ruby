module StringGenerator
  ALPHABET = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  EXTENDED_ALPHABET = %w(à ê í õ ß Ä Ů Ž Ç)

  def StringGenerator.generate_string(length = 10, include_special_chars = false, capitalize = true)
    result = (0...length).map { ALPHABET[rand(ALPHABET.length)] }.join
    if include_special_chars
      result[rand(result.length)] = EXTENDED_ALPHABET[rand(EXTENDED_ALPHABET.length)]
    end
    if capitalize
      result.capitalize!
    end
    result
  end

  def StringGenerator.generate_special_string(length = 10)
    generate_string(length, true)
  end
end