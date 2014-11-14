require 'rails_helper'

describe TrelloApi do
  let(:client) { TrelloApi.new(ENV['TRELLO_KEY'], ENV['TRELLO_TOKEN']) }

  context 'getters', :vcr do
    it '#get_card_name' do
      expect(client.get_card_name('4D061Xdw')).to eql 'Test #get_card_name'
    end

    it '#set_card_name' do
      name = client.set_card_name('nb4Xe2oZ', 'Test #set_card_name')
      expect(name).to eql 'Test #set_card_name'
    end
  end

  context '#update_card_hours' do
    it 'updates trello card name', :vcr do
      res = client.update_card_hours('z67DFiHm', 2.0)
      expect(res).to eql 'Test hours used in test [2.0]'
    end
  end

  context '#create_comment', :vcr do
    it 'creates a comment on a card' do
      res = client.create_comment('Iau2e1Uc', 'a new comment')
      expect(res).to eql 'a new comment'
    end
  end
end
