class Model::Credentials
  attr_accessor :username, :password

  def initialize(email, password)
    @username = email
    @password = password
  end

  def self.create_mock
    email = "autotest+pmnts#{DateTime.now.strftime('%Y%m%dt%H%M%S')}@example.com"
    Model::Credentials.new(email, email)
  end
end
