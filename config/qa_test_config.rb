module QaTestConfig
  extend self

  @env
  attr_reader :global_config, :config

  # Read main configuration file
  begin
    @env = ENV['TEST_ENV'] || 'theta'
    dirname = File.dirname(__FILE__)
    @global_config = YAML::load_file(File.join(dirname, 'tests-config.yml'))['global']
    @config = YAML::load_file(File.join(dirname, 'tests-config.yml'))[@env]

    raise "Configuration section '#{@env}' not found in tests-config.yml" if @config.nil?
  end

  # ActiveRecord connection establish
  begin
    db_user =  QaTestConfig.config['db_user'] || QaTestConfig.global_config['db_user']
    db_password = ENV['DB_PASSWORD'] || QaTestConfig.config['db_password'] || QaTestConfig.global_config['db_password']
    db_host = QaTestConfig.config['db_host'] || QaTestConfig.global_config['db_host']
    db_port = QaTestConfig.config['db_port'] || QaTestConfig.global_config['db_port']
    db_name = QaTestConfig.config['db_name'] || QaTestConfig.global_config['db_name']

    if db_user.nil? || db_password.nil? || db_host.nil? || db_port.nil? || db_name.nil?
      warn ('Missing Postgresql parameters. Tests may fail')
    else
      ENV['DATABASE_URL'] = URI::Generic.new('postgresql',
                                             "#{db_user}:#{db_password}",
                                             db_host,
                                             db_port, nil,
                                             "/#{db_name}", nil, nil, nil).to_s
      ActiveRecord::Base.establish_connection
      # ActiveRecord::Base.logger = Logger.new(STDOUT)
    end
  rescue Exception => ex
    warn "There was an error connecting ActiveRecord:\n#{ex.message}\n#{ex.backtrace.to_s}"
  end

  # Prevent .to_json from breaking characters like '<', '>'
  ActiveSupport.escape_html_entities_in_json = false

  def self.env
    @env
  end

  module_function

  def GetValueFromEnvOrConfig(key, default_value = nil)
    val = ENV[key]
    val = ENV[key.upcase] if val.nil?
    val = QaTestConfig.config[key] if val.nil?
    val = QaTestConfig.global_config[key] if val.nil?
    val = default_value if val.nil?
    val
  end

end
