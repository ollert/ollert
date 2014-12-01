require_relative '../../../../utils/connecting/user_connector'
require_relative '../../../../models/user'

describe 'UserConnector' do
  before :each do
    @client = double(Trello::Client)
    @member = {"id" => "d3912324fff",
      "username" => "mo_money_mo_problems",
      "gravatarHash" => "13213feufd",
      "email" => "kanye@email.com"
    }
    @new_token = "1234567"
  end

  it 'returns 500 on Trello Error' do
    expect(MemberFetcher).to receive(:fetch).and_raise(Trello::Error)

    result = UserConnector.connect(@client, @new_token)
    expect(result[:body]).to eq("There's something wrong with the Trello connection. Please re-establish the connection.")
    expect(result[:status]).to eq(500)
  end

  it 'gets user for login and returns 200 when not given current user' do
    expect(MemberFetcher).to receive(:fetch).and_return(nil)
    expect(MemberAnalyzer).to receive(:analyze).and_return(@member)
    user = double(User)
    expect(User).to receive(:find_or_initialize_by).with(trello_id: @member["id"]).once.and_return(user)
    expect(@client).to receive(:delete).never
    expect(user).to receive(:save).once
    expect(user).to receive(:member_token).and_return(nil)
    expect(user).to receive(:member_token=).with(@new_token)
    expect(user).to receive(:trello_id=).with(@member["id"])
    expect(user).to receive(:trello_name=).with(@member["username"])
    expect(user).to receive(:gravatar_hash=).with(@member["gravatarHash"])
    expect(user).to receive(:email=).with(@member["email"])
    member_id = "jdoi10fj39012092"
    expect(user).to receive(:id).and_return(member_id)

    result = UserConnector.connect(@client, @new_token)
    expect(result[:body]).to eq({username: @member["username"], gravatar_hash: @member["gravatarHash"]}.to_json)
    expect(result[:id]).to eq member_id
    expect(result[:status]).to eq(200)
  end

  it 'deletes any existing tokens with existing user' do
    expect(MemberFetcher).to receive(:fetch).and_return(nil)
    expect(MemberAnalyzer).to receive(:analyze).and_return(@member)
    user = double(User)
    existing_token = "dke9k9921939309302"
    expect(User).to receive(:find_or_initialize_by).with(trello_id: @member["id"]).once.and_return(user)
    expect(@client).to receive(:delete).with("/tokens/#{existing_token}").once
    expect(user).to receive(:save).once
    expect(user).to receive(:member_token).and_return(existing_token).exactly(3).times
    expect(user).to receive(:member_token=).with(@new_token)
    expect(user).to receive(:trello_id=).with(@member["id"])
    expect(user).to receive(:trello_name=).with(@member["username"])
    expect(user).to receive(:gravatar_hash=).with(@member["gravatarHash"])
    expect(user).to receive(:email=).with(@member["email"])
    member_id = "jdoi10fj39012092"
    expect(user).to receive(:id).and_return(member_id)

    result = UserConnector.connect(@client, @new_token)
    expect(result[:body]).to eq({username: @member["username"], gravatar_hash: @member["gravatarHash"]}.to_json)
    expect(result[:id]).to eq member_id
    expect(result[:status]).to eq(200)
  end

  it 'does not care when client throws while deleting token' do
    expect(MemberFetcher).to receive(:fetch).and_return(nil)
    expect(MemberAnalyzer).to receive(:analyze).and_return(@member)
    user = double(User)
    existing_token = "dke9k9921939309302"
    expect(User).to receive(:find_or_initialize_by).with(trello_id: @member["id"]).once.and_return(user)
    expect(@client).to receive(:delete).with("/tokens/#{existing_token}").once.and_raise(Trello::Error)
    expect(user).to receive(:save).once
    expect(user).to receive(:member_token).and_return(existing_token).exactly(3).times
    expect(user).to receive(:member_token=).with(@new_token)
    expect(user).to receive(:trello_id=).with(@member["id"])
    expect(user).to receive(:trello_name=).with(@member["username"])
    expect(user).to receive(:gravatar_hash=).with(@member["gravatarHash"])
    expect(user).to receive(:email=).with(@member["email"])
    member_id = "jdoi10fj39012092"
    expect(user).to receive(:id).and_return(member_id)

    result = UserConnector.connect(@client, @new_token)
    expect(result[:body]).to eq({username: @member["username"], gravatar_hash: @member["gravatarHash"]}.to_json)
    expect(result[:id]).to eq member_id
    expect(result[:status]).to eq(200)
  end

  it 'gets user for login and returns 200 when given matching current user' do
    expect(MemberFetcher).to receive(:fetch).and_return(nil)
    expect(MemberAnalyzer).to receive(:analyze).and_return(@member)
    user = double(User)
    expect(user).to receive(:save).once
    expect(user).to receive(:member_token).and_return(@new_token).exactly(2).times
    expect(user).to receive(:member_token=).with(@new_token)
    expect(user).to receive(:trello_id).and_return(@member["id"])
    expect(user).to receive(:trello_id=).with(@member["id"])
    expect(user).to receive(:trello_name=).with(@member["username"])
    expect(user).to receive(:gravatar_hash=).with(@member["gravatarHash"])
    expect(user).to receive(:email=).with(@member["email"])
    member_id = "jdoi10fj39012092"
    expect(user).to receive(:id).and_return(member_id)

    result = UserConnector.connect(@client, @new_token, user)
    expect(result[:body]).to eq({username: @member["username"], gravatar_hash: @member["gravatarHash"]}.to_json)
    expect(result[:id]).to eq member_id
    expect(result[:status]).to eq(200)
  end

  it 'returns 400 when current user tries to replace existing user' do
    expect(MemberFetcher).to receive(:fetch).and_return(nil)
    expect(MemberAnalyzer).to receive(:analyze).and_return(@member)
    user = double(User)
    existing_user = double(User)
    expect(User).to receive(:find_by).with(trello_id: @member["id"]).once.and_return(existing_user)
    expect(user).to receive(:trello_id).and_return("junk id")

    result = UserConnector.connect(@client, @new_token, user)
    expect(result[:body]).to eq("User already exists using that account. Log out to connect with that account.")
    expect(result[:status]).to eq(400)
  end
end