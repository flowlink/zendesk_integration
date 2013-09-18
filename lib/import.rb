class Import
  def initialize(client, severity, payload, name, email)
    @ticket = ZendeskAPI::Ticket.new(client) # doesn't actually send a request, must explicitly call #save
    @ticket.priority = map_priority(severity)
    @ticket.status = "new"
    @ticket.requester = { "name" => name, "email" => email }
    @ticket.subject = payload["subject"]
    @ticket.comment = { :value => payload["description"] }
    raise "Unable to save" unless @ticket.save
  end

  def map_priority(priority)
    case priority
    when "notification:warning"
      @config["zendesk.warning_priority"] || "high" # whatever they have configured for notification warning
    when "notification:error"
      @config["zendesk.error_priority"] || "urgent" # whatever they have configured for error warning
    end
  end
end