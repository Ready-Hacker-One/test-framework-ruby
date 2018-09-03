Before do |scenario|
  puts 'STARTING SCENARIO : '  + "#{scenario.name}"
  $sharedState = SharedState.new
end

After do
  puts 'TX_CODE: ' + $sharedState.tx.server_responses[-1].transaction.tx_code.upcase
  rescue
    # do nothing
end

at_exit do
  ReportBuilder.build_report
end