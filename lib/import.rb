class Import
  def initialize(client, severity, payload, config)
    @ticket = ZendeskAPI::Ticket.new(client) # doesn't actually send a request, must explicitly call #save
    @ticket.priority = map_priority(severity, config)
    @ticket.status = "new"
    @ticket.requester = { "name" => config["zendesk.requester_name"], "email" => config["zendesk.requester_email"] }
    @ticket.subject = payload["subject"]
    @ticket.comment = { "body" => payload["description"] }
    raise "Unable to save" unless @ticket.save
  end

  def ticket
    @ticket
  end

  def map_priority(priority, config)
    case priority
    when "notification:warning"
      config["zendesk.warning_priority"] || "high"
    when "notification:error"
      config["zendesk.error_priority"] || "urgent"
    else
      "normal"
    end
  end
end
