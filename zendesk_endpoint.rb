require "sinatra"
require "endpoint_base"

Dir['./lib/*.rb'].each { |f| require f }

class ZendeskEndpoint < EndpointBase::Sinatra::Base
  endpoint_key ENV['ENDPOINT_KEY']

  post '/import' do
    begin
      client = Client.new(@config)
      import = Import.new(client.fetch, @payload, @config)

      ticket = import.ticket
      result 200, "New Zendesk ticket number #{ticket.id} created, priority: #{ticket.priority}." 
    rescue => e
      result 500, e.message
    end
  end
end
