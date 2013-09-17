class Import
  def initialize(client, severity, payload, name, email)
    @ticket = ZendeskAPI::Ticket.new(client) # doesn't actually send a request, must explicitly call #save
    @ticket.priority = severity
    @ticket.requester = { "name" => name, "email" => email }
    @ticket.subject = payload['subject']
    @ticket.comment = { :value => payload['body'] }
    raise "Unable to save" unless @ticket.save
  end
end