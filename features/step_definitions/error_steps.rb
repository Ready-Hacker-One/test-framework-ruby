Then (/^Expected Error "(.*)" is returned/) do |error|
  if error == $sharedState.response_code.to_s
    result = 'EXPECTED ERROR ' + $sharedState.response_code.to_s + ' is returned. ' + $sharedState.error_message
    puts result.colorize(:green)
  else
    puts 'Service returned : ' + $sharedState.response_code.to_s + $sharedState.error_message
    raise 'UNEXPECTED ERROR IS RETURNED'
  end
end