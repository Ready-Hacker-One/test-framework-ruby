class AuthService < ServiceBase
  AUTH_PATH = QaTestConfig.config['api_triangle_url'] + '/api/0.1/auth'

  def self.login_merchant(username, password)
    authRequest = Model::TriangleLogin.new(username, password)
    authResponse = base_post(AUTH_PATH, Model::RpcRequest.new('login', authRequest))
    authResponse.result
  end
end