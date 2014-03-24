require 'zendesk_api'

class Client
  def initialize(configuration)
    @client = ZendeskAPI::Client.new do |config|

      # Mandatory:
      config.url = configuration["zendesk_url"] # e.g. https://mydesk.zendesk.com/api/v2
      config.username = configuration["zendesk_username"]
      config.password = configuration["zendesk_password"]

      # Optional:

      # Retry uses middleware to notify the user
      # when hitting the rate limit, sleep automatically,
      # then retry the request.
      config.retry = false

      # Logger prints to STDERR by default, to e.g. print to stdout:
      require 'logger'
      config.logger = Logger.new(STDOUT)

      # Changes Faraday adapter
      # config.adapter = :patron

      # Merged with the default client options hash
      # config.client_options = { :ssl => true }

      # When getting the error 'hostname does not match the server certificate'
      # use the API at https://yoursubdomain.zendesk.com/api/v2
    end

    @client
  end

  def fetch
    @client
  end
end
