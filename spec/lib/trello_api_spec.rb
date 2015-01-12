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

  context '#update_card_hours', :vcr do
    it 'updates trello card name' do
      num = sprintf('%.2f', rand(0.0..5.0)).to_f
      res = client.update_card_hours('z67DFiHm', num)
      expect(res).to eql "Test hours used in test [#{num}]"
    end

    it 'doesn\'t set name when it\'s the same' do
      expect(client).to_not receive(:set_card_name)

      res = client.update_card_hours('SGMaMQ4D', 0.5)

      expect(res).to eql false
    end

    it 'returns false on Trello::Error to notify failure and let process continue' do
      res = client.update_card_hours('123456', 0.5)

      expect(res).to eql false
    end

    it 'notifies airbrake on Trello::Error' do
      expect(client).to receive(:update_card_hours).and_call_original
      expect(client).to receive(:notify_airbrake)

      res = client.update_card_hours('123456', 0.5)
    end
  end

  context '#create_comment', :vcr do
    it 'creates a comment on a card' do
      res = client.create_comment('Iau2e1Uc', 'a new comment')
      expect(res).to eql 'a new comment'
    end
  end
end
