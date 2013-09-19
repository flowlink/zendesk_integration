require 'spec_helper'

# describe "Sinatra App" do
describe ZendeskEndpoint do

  def auth 
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
  end

  def app
    described_class
    # ZendeskEndpoint
  end

  let(:error_notification_payload) { { "message" => "notification:error", "message_id" => "518726r84910515003", "payload" => { "subject" => "Invalid China Order", "description" => "This order is shipping to China but was invalidly sent to PCH" } } }
  let(:warning_notification_payload) { { "message" => "notification:warning", "message_id" => "518726r84910515004", "payload" => { "subject" => "Item out of stock", "description" => "This products requested in this order are not in stock." } } }
  let(:info_notification_payload) { { "message" => "notification:info", "message_id" => "518726r84910515005", "payload" => { "subject" => "Order Received", "description" => "You have received an order." } } }

  it "should respond to POST error notification import" do
    error_notification_payload['payload']['parameters'] = [ 
      { 'name' => 'zendesk.username', 'value' => 'someone@example.com' },
      { 'name' => 'zendesk.password', 'value' => 'password123' },
      { 'name' => 'zendesk.url', 'value' => 'https://awesomeness.zendesk.com/api/v2/' },
      { 'name' => 'zendesk.requester_name', 'value' => 'Spree Integrator' },
      { 'name' => 'zendesk.requester_email', 'value' => 'support@spreecommerce.com' },
      { 'name' => 'zendesk.warning_priority', 'value' => 'normal' },
      { 'name' => 'zendesk.error_priority', 'value' => 'high' } ]

    VCR.use_cassette('error_notification_import') do
      post '/import', error_notification_payload.to_json , auth
      last_response.status.should == 200
      last_response.body.should match /"Help ticket created"/
    end
  end

  it "should respond to POST warning notification import" do
    warning_notification_payload['payload']['parameters'] = [ 
      { 'name' => 'zendesk.username', 'value' => 'someone@example.com' },
      { 'name' => 'zendesk.password', 'value' => 'password123' },
      { 'name' => 'zendesk.url', 'value' => 'https://awesomeness.zendesk.com/api/v2/' },
      { 'name' => 'zendesk.requester_name', 'value' => 'Spree Integrator' },
      { 'name' => 'zendesk.requester_email', 'value' => 'support@spreecommerce.com' },
      { 'name' => 'zendesk.warning_priority', 'value' => 'normal' },
      { 'name' => 'zendesk.error_priority', 'value' => 'high' } ]

    VCR.use_cassette('warning_notification_import') do
      post '/import', warning_notification_payload.to_json , auth
      last_response.status.should == 200
      last_response.body.should match /"Help ticket created"/
    end
  end
end
