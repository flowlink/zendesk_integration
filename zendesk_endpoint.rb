Dir['./lib/*.rb'].each { |f| require f }

class ZendeskEndpoint < EndpointBase::Sinatra::Base
  endpoint_key ENV['ENDPOINT_KEY']

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/create_ticket' do
    client = Client.new(@config)
    instance = Import.new(client.fetch, @payload, @config)

    if instance.save
      ticket = instance.ticket
      result 200, "New Zendesk ticket number #{ticket.id} created, priority: #{ticket.priority}."
    else
      result 500, "Unable to save"
    end
  end
end
