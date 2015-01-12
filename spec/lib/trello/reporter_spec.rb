require 'rails_helper'

describe Trello::Reporter do
  let(:client)   { TrelloApi.new(ENV['TRELLO_KEY'], ENV['TRELLO_TOKEN']) }
  let(:reporter) { Trello::Reporter.new(client) }

  context '#report', :vcr do
    it 'returns an array with cards' do
      cards = client.report(board_ids: ['wusd8mr6'])
      card_keys = %w(
        name desc short_link short_url actual estimate
        created_at board_id board_name
      )
      expect(cards.length).to be > 0
      expect(cards.first.keys).to eq card_keys
    end
  end

  context '#date_from_id' do
    subject { reporter.date_from_id('4d5ea62fd76aa1136000000c') }

    it 'gets a datetime' do
      expect(subject).to be_an_instance_of(DateTime)
    end

    it 'gets correct date' do
      # deal with CI time zone differences
      time_string = subject.in_time_zone('Central Time (US & Canada)').to_s
      expect(time_string).to eq '2011-02-18 11:02:39 -0600'
    end
  end

end
