require_relative '../spec_helper'

describe Util::ListAction do
  let(:client) { double Trello::Client }
  let(:right_now) { Time.now }
  let(:_) { anything }

  context 'ListAction.all' do
    let(:actions) { Util::ListAction.actions(client, TrelloHelper.board_id, since: right_now.to_s).sort_by(&:date) }
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

    it 'includes created, moved and closed cards' do
      actions
      expect(client).to have_received(:get).with(_, hash_including(filter: 'createCard,updateCard:idList,updateCard:closed'))
    end

    context 'fields' do
      let(:raw) { {date: Time.now, data: {card: {}}} }
      let(:card) { raw[:data][:card] }
      let(:result) do
        expect(client).to receive(:get).and_return [raw].to_json
        actions.first
      end

      it 'maps the card information' do
        card[:name] = 'expected card name'
        card[:id] = 'expected card id'

        expect(result.card).to eq('expected card name')
        expect(result.card_id).to eq('expected card id')
      end
    end
  end
end
