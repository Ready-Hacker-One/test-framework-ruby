require 'report_builder'

time = Time.now.getutc
ReportBuilder.configure do |config|
  config.json_path = 'test-output/features_report.json'
  config.report_path = 'test-output/features_report'
  config.report_types = [:html]
  config.report_tabs = %w[Overview Features Scenarios Errors]
  config.report_title = 'TBD Test Results'
  config.compress_images = false
  config.additional_info = { 'Project name' => 'TBD', 'Platform' => QaTestConfig.env.upcase, 'Report generated' => time }
end