module Model
  class SendResponses < BaseParamsAuthRequest
    attr_accessor :reader, :tx_id

    def initialize(access_token, server_tx_id, responses)
      super(access_token)
      @tx_id = server_tx_id
      @reader = Reader.new(responses)
    end

    class Reader
      attr_accessor :responses

      def initialize(responses)
        @responses = []
        responses.each {|response| @responses.append(Response.new(response))}
      end
    end

    class Response
      attr_accessor :is_successful, :response

      def initialize(response)
        @is_successful = true
        @response = response
      end
    end
  end
end