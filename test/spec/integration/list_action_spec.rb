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
      let(:data) { raw[:data] }
      let(:card) { data[:card] }
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

      context 'updateCard' do
        let(:before) { data[:listBefore] = {} }
        let(:after) { data[:listAfter] = {} }

        it 'maps the before list' do
          before[:name] = 'expected list'
          before[:id] = 'expected list id'

          expect(result.before).to eq('expected list')
          expect(result.before_id).to eq('expected list id')
        end

        it 'maps the after list' do
          after[:name] = 'expected list'
          after[:id] = 'expected list id'

          expect(result.after).to eq('expected list')
          expect(result.after_id).to eq('expected list id')
        end
      end

      context 'createCard' do
        let(:list) { data[:list] = {} }

        it 'does not have a before list' do
          expect(result.before).to be_nil
          expect(result.before_id).to be_nil
        end

        it 'uses "list" as the after list' do
          list[:name] = 'expected list'
          list[:id] = 'expected list id'

          expect(result.after).to eq('expected list')
          expect(result.after_id).to eq('expected list id')
        end
      end
    end
  end
end
