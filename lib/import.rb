class Import
  def initialize(client, severity, payload, name, email)
    @ticket = ZendeskAPI::Ticket.new(client) # doesn't actually send a request, must explicitly call #save
    @ticket.priority =  map_priority(severity)
    @ticket.requester = {"name" => name, "email" => email}
    @ticket.subject = payload['subject']
    @ticket.comment = { :value => payload['body'] }
    raise "Unable to save" unless @ticket.save
  end

  def map_priority(priority)
    case priority
    when "notification:info"
      "Normal"
    when "notification:warning"
      "High"
    else
      "Normal"
    end
  end
end