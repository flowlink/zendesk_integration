class Import
  def initialize(client, severity, payload, config)
    @ticket = ZendeskAPI::Ticket.new(client, :priority => map_priority(severity, config), :status => "new",
      :requester => { :name => config["zendesk.requester_name"], :email => config["zendesk.requester_email"],
      :role => "end-user" }, :subject => payload["subject"],
      :comment => { "body" => payload["description"] } ) # doesn't actually send a request, must explicitly call #save
    raise "Unable to save" unless @ticket.save
  end

  def ticket
    @ticket
  end

  def map_priority(priority, config)
    case priority
    when "notification:warn"
      config["zendesk.warning_priority"] || "high"
    when "notification:error"
      config["zendesk.error_priority"] || "urgent"
    else
      "normal"
    end
  end
end
