require 'spec_helper'

describe ZendeskEndpoint do
  let(:error_notification_payload) do
    { 
      "subject" => "Invalid China Order",
      "description" => "This order is shipping to China but was invalidly sent to PCH",
      "priority" => "error"
    }
  end

  let(:warning_notification_payload) do
    {
      "subject" => "Item out of stock",
      "description" => "This products requested in this order are not in stock.",
      "priority" => "warn"
    }
  end

  let(:info_notification_payload) do
    {
      "subject" => "Order Received",
      "description" => "You have received an order.",
      "priority" => "info"
    }
  end

  params = {
    'zendesk_username' => 'me@example.com',
    'zendesk_password' => 'password123',
    'zendesk_url' => 'https://example.zendesk.com/api/v2/',
    'zendesk_requester_name' => 'Spree Integrator',
    'zendesk_requester_email' => 'support@spreecommerce.com'
  }

  priority_params = {
    'zendesk_warning_priority' => 'normal',
    'zendesk_error_priority' => 'high'
  }

  full_params = params.merge priority_params

  it "should respond to POST error notification import" do
    error_notification_payload['parameters'] = full_params

    VCR.use_cassette('error_notification_import') do
      post '/create_ticket', error_notification_payload.to_json, auth
      expect(last_response.status).to eq 200
      expect(json_response[:summary]).to match "New Zendesk ticket"
    end
  end

  it "should respond to POST warning notification import" do
    warning_notification_payload['parameters'] = full_params

    VCR.use_cassette('warning_notification_import') do
      post '/create_ticket', warning_notification_payload.to_json, auth
      last_response.status.should == 200
      expect(json_response[:summary]).to match "New Zendesk ticket"
    end
  end

  it "should assign the custom warning priority to warning notifications" do
    warning_notification_payload['parameters']  = full_params

    VCR.use_cassette('custom_warning_priority') do
      post '/create_ticket', warning_notification_payload.to_json, auth
      last_response.body.should match /priority: normal/
    end
  end

  it "should assign the default warning priority to warning notifications without a custom setting" do
    warning_notification_payload['parameters'] = params

    VCR.use_cassette('default_warning_priority') do
      post '/create_ticket', warning_notification_payload.to_json, auth
      last_response.body.should match /priority: high/
    end
  end

  it "should assign the custom error priority to error notifications" do
    error_notification_payload['parameters']  = full_params

    VCR.use_cassette('custom_error_priority') do
      post '/create_ticket', error_notification_payload.to_json, auth
      last_response.body.should match /priority: high/
    end
  end

  it "should assign the default error priority to error notifications without a custom setting" do
    error_notification_payload['parameters'] = params

    VCR.use_cassette('default_error_priority') do
      post '/create_ticket', error_notification_payload.to_json, auth
      last_response.body.should match /priority: urgent/
    end
  end

  it "500 when cant save" do
    Import.any_instance.stub save: false
    error_notification_payload['parameters'] = full_params
    post '/create_ticket', error_notification_payload.to_json, auth

    expect(last_response.status).to eq 500
    expect(json_response[:summary]).to match "Unable to save"
  end
end
