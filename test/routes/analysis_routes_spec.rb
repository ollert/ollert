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
    let(:cards) { build_list(:trello_card, 5) }
    let(:actions) { [] }
    let(:times) { [] }

    before do
      allow(Utils::Fetchers::ListActionFetcher).to receive(:fetch).and_return(actions)
      allow(Utils::Analyzers::TimeTracker).to receive(:by_card).and_return(times)

      expect(trello_client).to receive(:get).with("/boards/#{board_id}/lists", filter: 'open')
        .and_return(lists.to_json)

      expect(trello_client).to receive(:get).with("/boards/#{board_id}/cards", fields: 'name,closed,idList,idBoard,shortUrl')
        .and_return(cards.to_json)

      get "/api/v1/listchanges/#{board_id}", token: token
    end

    subject { last_response }

    it { should be_ok }

    it 'asks for the correct actions' do
      expect(Utils::Fetchers::ListActionFetcher).to have_received(:fetch)
        .with(trello_client, board_id)
    end

    context 'TimeTracker' do
      let(:actions) { [{id: 1}, {id: 2}] }
      subject {  Utils::Analyzers::TimeTracker }

      it { should have_received(:by_card).with(cards: cards, actions: [{id: 1}, {id: 2}]) }
    end

    context 'json' do
      let(:expected_lists) do
        lists.map { |l| l.attributes.slice(:id, :name).stringify_keys }
      end
      let(:expected_cards) do
        cards.map { |c| c.attributes.slice(*%i(id name list_id closed)).stringify_keys }
      end

      subject { json_response_body }

      its(:keys) { should match_array(%w(lists times)) }

      its(%w(lists)) { should match_array(expected_lists) }
      its(%w(times)) { should be_empty }

      context 'times' do
        let(:times) { [{best_time: :ever}] }
        subject { super()['times'] }

        it { should eq [{'best_time' => 'ever'}] }
      end
    end
  end
end
