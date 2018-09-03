class Model::RpcRequest
  attr_accessor :jsonrpc, :method, :params, :id

  def initialize(method, params)
    @jsonrpc = '2.0'
    @method = method
    @params = params
    @id = SecureRandom.hex(10)
  end
end