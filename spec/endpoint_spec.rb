require 'spec_helper'

describe "Sinatra App" do

  def auth 
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
  end

  def app
    ZendeskEndpoint
  end

  let(:notification_payload) { { "key" => "notification:info", "payload" => { "subject" => "Invalid China Order", "body" => "This order is shipping to China but was invalidly sent to PCH" }, "store_id" => "51793f803950edcb7d000001" } }

  it "should respond to POST notification import" do
    notification_payload['payload']['parameters'] = [ { 'name' => 'zendesk.username', 'value' => 'adhlssu07@gmail.com' },
                                           { 'name' => 'zendesk.token', 'value' => 'NKo6pDX3t49jUIltGGVeOLvOURS7pLvzswhMCZsp' },
                                           { 'name' => 'zendesk.url', 'value' => 'https://testingawesome.zendesk.com/api/v2/' },
                                           { 'name' => 'zendesk.requester_name', 'value' => 'Spree Integrator' },
                                           { 'name' => 'zendesk.requester_email', 'value' => 'support@spreecommerce.com' }]


    VCR.use_cassette('notification_import') do
      post '/import', notification_payload.to_json , auth
      last_response.inspect.should == 200
      last_response.body.should match /"status":"sent"/
    end
  end
end

