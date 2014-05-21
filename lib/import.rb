class Import
  def initialize(client, payload, config)
    @ticket = ZendeskAPI::Ticket.new(
      client,
      :priority => 'normal',
      :status => "new",
      :requester => {
        :name => payload[:customer],
        :email => payload[:customer],
        :role => "end-user"
      },
      :subject => payload[:subject],
      :comment => { "body" => payload[:description] }
    ) # doesn't actually send a request, must explicitly call #save
  end

  def save
    @ticket.save
  end

  def ticket
    @ticket
  end
end
