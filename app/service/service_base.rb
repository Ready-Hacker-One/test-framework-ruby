class ServiceBase

  def self.base_get(path, headers = nil)
    begin
      RestClient.get(path, headers)
    rescue => e
      print_and_store_exception_response('GET', e)
      raise e
    end
  end

  def self.base_post(path, payload, headers = {})
    begin
      request_headers = {content_type: :json}
      request_headers.merge! headers unless headers.nil?
      request_json = payload.to_json
      self.print_request('POST', request_json)
      response = RestClient.post(path, request_json, request_headers)
      if response.body.length > 0
        responseBody = OpenStruct.new(JSON.parse(response.body, object_class:OpenStruct))
        puts response.body
      else
        responseBody = ''
      end
      responseBody
    rescue => e
      print_and_store_exception_response('POST', e)
      raise e
    end
  end

  def self.rpc_post(path, method, payload, headers = {})
    rpc_request = Model::RpcRequest.new(method, payload)
    response = ServiceBase.base_post(path, rpc_request, headers)
    if !response.error.nil? or response.result.nil?
      raise "Error response from server: #{response.error.to_h}"
    end
    response.result
  end

  def self.base_put(path, payload)
    begin
      request_json = payload.to_json
      self.print_request('PUT', request_json)
      RestClient.put(path, request_json, {content_type: :json})
    rescue => e
      print_and_store_exception_response('PUT', e)
      raise e
    end
  end

  def self.base_delete(path, headers=nil)
    begin
      RestClient.delete(path, headers)
    rescue => e
      print_and_store_exception_response('DELETE', e)
      raise e
    end
  end

  def self.print_request(method, payload)
    return if payload.nil?
    payload_json = payload.to_json
    puts "Going to #{method}: #{payload_json}" if payload_json.size >= 500
  end

  def self.print_and_store_exception_response(method, ex)
    if ex.is_a?(RestClient::Exception)
      $sharedState.response_code = ex.http_code
      $sharedState.error_message= ex.http_body
      puts ("#{method} error body: #{ex.http_body}").colorize(:yellow) if ex.http_body
    end
  end

end