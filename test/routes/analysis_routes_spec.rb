RSpec.describe 'analysis routes' do
  let(:trello_client) { double 'trello client' }
  let(:token) { 'fake token' }

  before do
    expect(Trello::Client).to receive(:new)
      .with(developer_public_key: ENV['PUBLIC_KEY'], member_token: 'fake token')
      .and_return(trello_client)
  end

  describe '/api/v1/listchanges/:board_id' do
    let(:board_id) { 'abc-def' }
    let(:lists) { build_list(:trello_list, 5) }

    before do
      allow(Utils::Fetchers::ListActionFetcher).to receive(:fetch).and_return []

      expect(trello_client).to receive(:get).with("/boards/#{board_id}/lists", filter: 'open')
        .and_return(lists.to_json)

      get "/api/v1/listchanges/#{board_id}", token: token
    end

    subject { last_response }

    it { should be_ok }

    context 'response' do
      let(:expected_lists) do
        lists.map { |l| { 'id' => l.id, 'name' => l.name } }
      end

      subject { json_response_body }

      its(%w(lists)) { should match_array(expected_lists) }
    end
  end
end
