require "sinatra"
require "endpoint_base"

Dir['./lib/*.rb'].each { |f| require f }

class ZendeskEndpoint < EndpointBase::Sinatra::Base
  endpoint_key ENV['ENDPOINT_KEY']

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/create_ticket' do
    client = Client.new(@config)
    import = Import.new(client.fetch, @payload, @config)

    ticket = import.ticket
    result 200, "New Zendesk ticket number #{ticket.id} created, priority: #{ticket.priority}."
  end
end
