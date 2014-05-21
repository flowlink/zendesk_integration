require 'spec_helper'

describe ZendeskEndpoint do
  let(:error_notification_payload) do
    {
      "ticket" => {
        "subject" => "Invalid China Order",
        "description" => "This order is shipping to China but was invalidly sent to PCH",
        "customer" => "example@spreecommerce.com"
      }
    }
  end

  let(:warning_notification_payload) do
    {
      "ticket" => {
        "subject" => "Item out of stock",
        "description" => "This products requested in this order are not in stock.",
        "customer" => "example@spreecommerce.com"
      }
    }
  end

  let(:info_notification_payload) do
    {
      "ticket" => {
        "subject" => "Order Received",
        "description" => "You have received an order.",
        "customer" => "example@spreecommerce.com"
      }
    }
  end

  params = {
    'zendesk_username' => 'spree@spreecommerce.com',
    'zendesk_password' => 'foobar',
    'zendesk_url' => 'https://example.zendesk.com/api/v2',
  }

  it "should respond to POST error notification import" do
    error_notification_payload['parameters'] = params

    VCR.use_cassette('error_notification_import') do
      post '/create_ticket', error_notification_payload.to_json, auth
      expect(last_response.status).to eq 200
      expect(json_response[:summary]).to match "New Zendesk ticket"
    end
  end

  it "should respond to POST warning notification import" do
    warning_notification_payload['parameters'] = params

    VCR.use_cassette('warning_notification_import') do
      post '/create_ticket', warning_notification_payload.to_json, auth
      last_response.status.should == 200
      expect(json_response[:summary]).to match "New Zendesk ticket"
    end
  end

  it "500 when cant save" do
    Import.any_instance.stub save: false
    error_notification_payload['parameters'] = params
    post '/create_ticket', error_notification_payload.to_json, auth

    expect(last_response.status).to eq 500
    expect(json_response[:summary]).to match "Unable to save"
  end
end
