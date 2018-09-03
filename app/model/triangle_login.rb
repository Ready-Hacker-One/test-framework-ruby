module Model
  class TriangleLogin < BaseParamsRequest
    attr_accessor :username, :password, :location, :language, :locale, :ip, :app, :device

    def initialize(username, password)
      super()
      @username = username
      @password = password
      @hashed = false
      @language = 'en'
      @locale = 'en_GB'
      @ip = '127.0.0.1'
    end
  end
end