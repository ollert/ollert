require_relative '../spec_helper'

describe Util::ListAction, integration: true do
  let(:client) { TrelloHelper.client }
  let(:right_now) { @first_card.last_activity_date - 1 }
  let(:_) { anything }

  before(:all) do
    @first_card = TrelloHelper.add_card
  end

  context 'ListAction.all' do
    let(:actions) { Util::ListAction.actions(client, TrelloHelper.board_id, since: right_now.to_s).sort_by(&:date) }

    context 'the call' do
      let(:response) { [{date: Time.now, data: {card: {}}}].to_json }
      before(:each) { allow(client).to receive(:get).and_return(response) }

      it 'just wants the actions' do
        actions
        expect(client).to have_received(:get).with("/boards/#{TrelloHelper.board_id}/actions", _)
      end

      it 'can pass additional information' do
        actions
        expect(client).to have_received(:get).with(_, hash_including(since: right_now.to_s))
      end
    end

    it 'includes created, moved and closed cards' do
      @first_card.move_to_list TrelloHelper.second_list
      @first_card.close!

      expect(actions.map(&:type)).to eq(['createCard', 'updateCard', 'updateCard'])
    end
  end
end
