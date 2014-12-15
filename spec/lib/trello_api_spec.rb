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
  end

  context '#create_comment', :vcr do
    it 'creates a comment on a card' do
      res = client.create_comment('Iau2e1Uc', 'a new comment')
      expect(res).to eql 'a new comment'
    end
  end

  context '#report', :vcr do
    it 'returns an array with cards' do
      cards = client.report(board_ids: ['wusd8mr6'])
      expect(cards.length).to be > 0
      expect(cards.first.keys).to eq ['id', 'name', 'desc', 'shortLink',
                                      'shortUrl', 'actual', 'estimate',
                                      'createdAt']
    end
  end

  context '#date_from_id' do
    subject { client.date_from_id('4d5ea62fd76aa1136000000c') }

    it 'gets a datetime' do
      expect(subject).to be_an_instance_of(DateTime)
    end

    it 'gets correct date' do
      # deal with CI time zone differences
      time_string = subject.in_time_zone('Central Time (US & Canada)').to_s
      expect(time_string).to eq "2011-02-18 11:02:39 -0600"
    end
  end
end
