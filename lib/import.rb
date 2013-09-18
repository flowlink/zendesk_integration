class Import
  def initialize(client, severity, payload, name, email)
    @ticket = ZendeskAPI::Ticket.new(client) # doesn't actually send a request, must explicitly call #save
    @ticket.priority = map_priority(severity)
    @ticket.status = "new"
    @ticket.requester = { "name" => name, "email" => email }
    @ticket.subject = payload["subject"]
    @ticket.comment = payload["description"]
    raise "Unable to save" unless @ticket.save
  end

  def map_priority(priority)
    case priority
    when "notification:warning"
      @config["zendesk.warning_priority"] || "high"
    when "notification:error"
      @config["zendesk.error_priority"] || "urgent"
    else
      "normal"
    end
  end
end