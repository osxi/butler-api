require 'rails_helper'

describe TrelloCardParser do
  context '#card_id' do
    context 'with card id' do
      subject { TrelloCardParser.new('Hello (GyMwvpq9)') }

      its(:card_id) { should eql 'GyMwvpq9' }
    end

    context 'without card id' do
      subject { TrelloCardParser.new('Hello') }

      its(:card_id) { should eql :no_card_id_found }
    end
  end
end
