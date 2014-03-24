class Import
  def initialize(client, payload, config)
    @ticket = ZendeskAPI::Ticket.new(
      client,
      :priority => map_priority(payload[:priority], config),
      :status => "new",
      :requester => {
        :name => config["zendesk_requester_name"],
        :email => config["zendesk_requester_email"],
        :role => "end-user"
      },
      :subject => payload["subject"],
      :comment => { "body" => payload["description"] }
    ) # doesn't actually send a request, must explicitly call #save

    raise "Unable to save" unless @ticket.save
  end

  def ticket
    @ticket
  end

  def map_priority(priority, config)
    case priority
    when "warn"
      config["zendesk_warning_priority"] || "high"
    when "error"
      config["zendesk_error_priority"] || "urgent"
    else
      "normal"
    end
  end
end
