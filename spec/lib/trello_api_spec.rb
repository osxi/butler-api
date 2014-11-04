require 'rails_helper'

describe TrelloApi do
  let(:client) { TrelloApi.new(ENV['TRELLO_KEY'], ENV['TRELLO_TOKEN']) }

  context 'getters', :vcr do
    it '#get_card_name' do
      expect(client.get_card_name('1xsvVRzN')).to eql 'used in a test'
    end

    it '#set_card_name' do
      name = client.set_card_name('EfPQpf4L', 'set used in test')
      expect(name).to eql 'set used in test'
    end
  end

  context '#update_card_hours', :vcr do
    it 'updates trello card name' do
      res = client.update_card_hours('depJGDst', 2.0)
      expect(res).to eql 'hours used in test [2.0]'
    end
  end
end
