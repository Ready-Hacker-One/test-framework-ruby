class Model::BaseParamsRequest
  attr_accessor :app, :device, :location

  def initialize
    @app = {:id => 'com.sumup.testautomation', :version => '1'}
    @device = {:model => 'Ruby', :name => 'Cucumber Automation', :system_name => "#{RUBY_PLATFORM}",
               :system_version => "#{RUBY_VERSION}", :uuid => 'TEST-AUTOMATION-FRAMEWORK'}
    @location = {:lat => 0.0, :lon => 0.0, :horizontal_accuracy => 10}
  end
end