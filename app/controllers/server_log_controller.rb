class ServerLogController
  def initialize
    @graylog_url = QaTestConfig.GetValueFromEnvOrConfig('graylog_url')
    @graylog_username = QaTestConfig.GetValueFromEnvOrConfig('graylog_username')
    @graylog_password = QaTestConfig.GetValueFromEnvOrConfig('graylog_password')
    @graylog_stream = QaTestConfig.GetValueFromEnvOrConfig('graylog_stream')
    @graylog_number_of_polls = [QaTestConfig.GetValueFromEnvOrConfig('graylog_number_of_polls').to_i, 3].max

    raise 'Not all Graylog settings found. Check config file' if @graylog_url.nil? or @graylog_username.nil? or \
                                                                 @graylog_password.nil? or @graylog_stream.nil?
  end

  def get_logs_for_tx(server_transaction_id, search_text, search_result_regex = nil)
    raise 'Server Transaction ID cannot be null' if server_transaction_id.nil?
    raise 'Search text cannot be null' if search_text.nil?

    request_token if @graylog_token.nil?

    search_term = "application_name:payment_pci AND \"#{server_transaction_id}\" AND #{search_text}"
    uri = URI("#{@graylog_url}/api/search/universal/relative?" \
            "query=#{search_term}" \
            "&filter=streams:#{@graylog_stream}" \
            '&range=100&fields=message&sort=timestamp:asc')
    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/json'
    request.basic_auth(@graylog_token, 'session')

    for i in 1..@graylog_number_of_polls do
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl=>true,
                                 :verify_mode=>OpenSSL::SSL::VERIFY_NONE) do |http|
        http.request(request)
      end

      throw_on_http_response_fail(response)

      result = JSON.parse(response.body)['messages']

      if result.try(:size) > 0
        filtered_msgs = result.collect{|msg| msg['message']['message']}
        filtered_msgs.reject!{|msg| msg !~ search_result_regex } if search_result_regex
        return filtered_msgs if filtered_msgs.size > 0
      end

      # God, don't kill me!
      # Graylog receives messages with delay, so most often than not
      # by the time we've requested logs there are no messages received yet
      puts "Graylog returned no results. Will sleep for #{i} second(s)".colorize(:yellow)
      sleep(i)
    end

    raise 'Could not fetch any Graylog messages'
  end

  private
  def request_token
    uri = URI("#{@graylog_url}/api/system/sessions")
    request = Net::HTTP::Post.new(uri)
    request['Accept'] = 'application/json'
    request.set_content_type('application/json')
    request.body = {:username => @graylog_username,
                    :password => @graylog_password,
                    :host => ''}.to_json
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl=>true,
                               :verify_mode=>OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(request)
    end
    throw_on_http_response_fail(response)
    @graylog_token = JSON.parse(response.body)['session_id']
  end

  def throw_on_http_response_fail(response)
    if response.kind_of?(Net::HTTPResponse) && !response.kind_of?(Net::HTTPSuccess)
      puts response.body.colorize(:red)
      response.value
    end
  end
end
