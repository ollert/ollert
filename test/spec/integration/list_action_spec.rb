require_relative '../spec_helper'

describe Util::ListAction do
  let(:client) { TrelloHelper.client }

  before(:all) do
    @first_card = TrelloHelper.add_card
  end

  context '#all' do
    let(:actions) { Util::ListAction.actions(client, TrelloHelper.board_id) }

    it 'includes creation' do
      expect(actions.map(&:card_id)).to include @first_card.id
    end
  end
end
