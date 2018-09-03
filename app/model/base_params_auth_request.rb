module Model
  class BaseParamsAuthRequest < BaseParamsRequest
    attr_accessor :accesstoken

    def initialize(access_token)
      super()
      @accesstoken = access_token
    end
  end
end