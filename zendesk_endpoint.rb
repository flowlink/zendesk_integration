# require 'endpoint_base'

Dir['./lib/*.rb'].each { |f| require f }

class ZendeskEndpoint < EndpointBase
  helpers Sinatra::JSON

  post '/import' do
    begin
      @config = config(@message)
      client = Client.new(@config)
      ticket = Import.new(client.fetch, (@message[:message] || @message[:key]), @message[:payload], @config["zendesk.requester_name"], @config["zendesk.requester_email"])
      code = 200
      result = { "message_id" => @message[:message_id], "message" => "notification:info", "payload" => { "subject" => "Help ticket created", "description" => "New Zendesk ticket created." } }
    rescue Exception => e
      code = 500
      result = { "error" => e.message, "trace" => e.backtrace.inspect }
    end
    process_result code, result
  end
end
